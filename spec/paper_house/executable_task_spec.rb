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
require 'paper_house/dsl'

describe Rake::Task do
  before { Rake::Task.clear }

  describe '.[]' do
    subject { Rake::Task[task] }

    context 'with :test' do
      let(:task) { :test }

      context 'when ExecutableTask named :test is defined' do
        before { PaperHouse::DSL::executable_task :test }

        describe '#invoke' do
          it do
            subject.invoke
          end
        end
      end

      context 'when ExecutableTask named :test is not defined' do
        it { expect { subject }.to raise_error }
      end
    end
  end
end

describe PaperHouse::ExecutableTask, '.new' do
  context 'with name :test' do
    subject { PaperHouse::DSL::executable_task :test }

    its(:cc) { should eq 'gcc' }
    its(:cflags) { should be_empty }
    its(:executable_name) { should eq 'test' }
    its(:includes) { should be_empty }
    its(:ldflags) { should be_empty }
    its(:library_dependencies) { should be_empty }
    its(:name) { should eq 'test' }
    its(:target_directory) { should eq '.' }
  end

  context 'with :test and block' do
    subject do
      PaperHouse::DSL::executable_task(:test) do | task |
        task.executable_name = executable_name
      end
    end

    context %{with #executable_name = 'new_name'} do
      let(:executable_name) { 'new_name' }

      its(:executable_name) { should eq 'new_name' }
    end

    context 'with #executable_name = :new_name' do
      let(:executable_name) { :new_name }

      its(:executable_name) { should eq :new_name }
    end
  end

end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
