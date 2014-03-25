# -*- coding: utf-8 -*-
#
# Copyright (C) 2013 NEC Corporation
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

require 'paper_house/build_task'
require 'paper_house/linker_options'
require 'paper_house/shared_library_task'
require 'paper_house/static_library_task'

module PaperHouse
  #
  # Compiles *.c files into an executable file.
  #
  class ExecutableTask < BuildTask
    include LinkerOptions

    # @!attribute executable_name
    #   Name of target executable file.
    attr_writer :executable_name

    def executable_name
      @executable_name ||= @name
    end
    alias_method :target_file_name, :executable_name

    def invoke(*args)
      @library_dependencies ||= []
      prerequisites.each do |dep|
        task = Rake::Task[dep]
        # There is no point in linking that way
        # Better directly pass the so file
        #@library_dependencies << task.lname if task.respond_to? :lname
        add_object task.target_path if task.respond_to? :target_path

      end
      super
    end

    private
    def generate_target
      sh(([cc] + cc_options).join(' '))
    end

    def cc_options
      [o_option, objects, ldflags, l_options].flatten
    end

    def o_option
      "-o #{target_path}"
    end
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
