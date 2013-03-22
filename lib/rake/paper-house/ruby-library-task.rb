#
# Copyright (C) 2013 NEC Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
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


require "rake/paper-house/library-task"
require "rake/paper-house/linker-options"


module Rake
  module PaperHouse
    #
    # Compile *.c files into a Ruby extension library.
    #
    class RubyLibraryTask < LibraryTask
      include LinkerOptions


      RUBY_INCLUDES = [
        File.join( RbConfig::CONFIG[ "rubyhdrdir" ], RbConfig::CONFIG[ "arch" ] ),
        File.join( RbConfig::CONFIG[ "rubyhdrdir" ], "ruby/backward" ),
        RbConfig::CONFIG[ "rubyhdrdir" ]
      ]


      ##########################################################################
      private
      ##########################################################################


      def target_file_name
        @library_name + ".so"
      end


      def generate_target
        sh "gcc -shared -o #{ target_path } #{ objects.to_s } #{ gcc_options }"
      end


      def gcc_options
        [
          @ldflags.join( " " ),
          gcc_ldflags,
          gcc_l_options,
        ].join " "
      end


      def gcc_ldflags
        "-L#{ RbConfig::CONFIG[ "libdir" ] }"
      end


      def gcc_i_options
        include_directories.collect do | each |
          "-I#{ each }"
        end.join( " " )
      end


      def include_directories
        [ @includes ].flatten + c_includes + RUBY_INCLUDES
      end
    end
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
