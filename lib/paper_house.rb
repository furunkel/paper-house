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

require 'paper_house/executable_task'
require 'paper_house/ruby_extension_task'
require 'paper_house/shared_library_task'
require 'paper_house/static_library_task'
require 'paper_house/config_task'
require 'paper_house/version'
require 'paper_house/dsl'

module PaperHouse
  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.templates
    File.join root, 'templates'
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
