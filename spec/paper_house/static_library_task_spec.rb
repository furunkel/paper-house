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

require 'paper_house/static_library_task'
require 'paper_house/dsl'

describe Rake::Task do
  before { Rake::Task.clear }

  describe '.[]' do
    subject { Rake::Task[task] }

    context 'with :libtest' do
      let(:task) { :libtest }

      context 'when StaticLibraryTask named :libtest is defined' do
        before { PaperHouse::DSL::static_library_task :libtest }

        describe '#invoke' do
          it do
            subject.invoke
          end
        end
      end

      context 'when StaticLibraryTask named :libtest is not defined' do
        it { expect { subject }.to raise_error }
      end
    end
  end
end

describe PaperHouse::StaticLibraryTask do
  before { Rake::Task.clear }

  describe '.find_named' do
    subject { PaperHouse::StaticLibraryTask.find_named name }

    context 'with :libtest' do
      let(:name) { :libtest }

      context 'when StaticLibraryTask named :libtest is defined' do
        before { PaperHouse::DSL::static_library_task :libtest }

        it { expect(subject).to be_a PaperHouse::StaticLibraryTask }
      end

      context 'when StaticLibraryTask named :libtest is not defined' do
        it { expect(subject).to be_nil }
      end
    end

    context %{with 'libtest'} do
      let(:name) { 'libtest' }

      context 'when StaticLibraryTask named :libtest is defined' do
        before { PaperHouse::DSL::static_library_task :libtest }

        it { expect(subject).to be_a PaperHouse::StaticLibraryTask }
      end
    end

    context 'with :no_such_task' do
      let(:name) { :no_such_task }

      it { expect(subject).to be_nil }
    end
  end

  describe '.new' do
    subject { PaperHouse::DSL::static_library_task task }

    context 'with :libtest' do
      let(:task) { :libtest }

      its(:cc) { should eq 'gcc' }
      its(:cflags) { should be_empty }
      its(:includes) { should be_empty }
      its(:name) { should eq 'libtest' }
      its(:target_directory) { should eq '.' }
      its(:library_name) { should eq 'libtest' }
      its(:lname) { should eq 'test' }
      its(:target_file_name) { should eq 'libtest.a' }
      its(:target_path) { should eq './libtest.a' }
    end
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
