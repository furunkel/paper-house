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

module PaperHouse
  module DSL
    def executable_task(name, *args, &block)
      task = ExecutableTask.define_task(name, *args)

      block.call(task) if block
      task.send :define_prerequisite_tasks

      task
    end

    def shared_library_task(name, *args, &block)
      options = (Hash === args.last) ? args.pop : {}
      task = SharedLibraryTask.define_task(name, *args)

      task.version = options[:version]
      block.call(task) if block
      task.send :define_prerequisite_tasks

      task
    end

    def static_library_task(name, *args, &block)
      task = StaticLibraryTask.define_task(name, *args)

      block.call(task) if block
      task.send :define_prerequisite_tasks

      task
    end

    def ruby_extension_task(name, *args, &block)
      task = RubyExtensionTask.define_task(name, *args)

      block.call(task) if block
      task.send :define_prerequisite_tasks

      task
    end

    extend self
  end
end
