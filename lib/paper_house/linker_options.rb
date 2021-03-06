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

module PaperHouse
  #
  # Linker option utilities.
  #
  module LinkerOptions
    # @!attribute ldflags
    #   Linker options pass to C compiler.
    attr_writer :ldflags

    def ldflags
      @ldflags ||= []
      [@ldflags].flatten.compact
    end

    #
    # List of libraries to link.
    #
    def library_dependencies=(name)
      @library_dependencies = [name].flatten.compact
    end

    #
    # List of libraries to link.
    #
    def library_dependencies
      @library_dependencies ||= []
      [@library_dependencies].flatten.compact
    end

    private

    def l_options
      library_dependencies.map do |each|
        "-l#{each}"
      end
    end
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
