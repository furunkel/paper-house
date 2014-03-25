# -*- coding: utf-8 -*-
#
# Copyright (C) 2014 Julian Aron Prenner
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 3, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

require 'erb'
require 'tempfile'

module PaperHouse
  class ConfigTask < Rake::Task

    def self.define_task(*args, &block)
      task = super(*args) do |t|
        t.send :write_header
      end

      block.call task
      task.send :set_prerequisites
      task
    end

    class HelperTask < Rake::Task
      attr_accessor :task
      attr_accessor :define_name

      def failed?
        @failed
      end

      def execute(*args)
        super
        begin
          @task.invoke(*args)
          @failed = false
        rescue PaperHouse::BuildFailed => error
          puts error.message
          @failed = true
        end
      end
    end

    class ERBUtil
      def initialize(values)
        @values = values
      end

      def method_missing(name, *args, &block)
        if @values.key?(name.to_sym)
          @values[name.to_sym]
        else
          super
        end
      end

      def render(template)
        ERB.new(template).result(binding)
      end

      def self.render_to_tempfile(values, template)
        tempfile = Tempfile.new ['paper_house_config', '.c']
        content = new(values).render(File.read template)
        tempfile.write(content)
        tempfile.close

        tempfile
      end
    end

    attr_accessor :headers
    attr_accessor :functions
    attr_accessor :macros

    attr_writer :target_path
    def target_path
      @target_path ||= "./#{name}_config.h"
    end

    #def invoke_prerequisites(*args)
    #  prerequisite_tasks.each{|t| t.invoke}
    #end

    private
    def set_prerequisites
      enhance((header_prerequisites +
        function_prerequisites +
        macro_prerequisites).map(&:name))
    end

    def header_prerequisites
      Array(headers).map do |header|
        tempfile = ERBUtil.render_to_tempfile({:header => header},
                                              File.join(PaperHouse.templates,
                                                        'have_header.c.erb'))
        
        executable_task = ExecutableTask.define_task "have_#{header}" do |t|
          t.sources = [tempfile.path]
        end

        helper_task = HelperTask.define_task "have_#{header}_helper"
        helper_task.task = executable_task
        helper_task.define_name = "HAVE_#{header.upcase.gsub(/-|\./, '_')}"

        helper_task
      end
    end

    def function_prerequisites
      []
    end

    def macro_prerequisites
      []
    end

    def write_header
      File.write(target_path, header_content)
    end

    def header_content
      prerequisite_tasks.map do |task|
        "#define #{task.define_name} #{task.failed?? 0: 1}"
      end.join("\n")
    end

  end
end
