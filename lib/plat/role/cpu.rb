module Plat
  module Role
    class Cpu < Plat::Role::Basic
      def ec2
        @ec2 ||= AWS::EC2.new(layout.aws_options)
      end
      def iam_role
        @iam_role ||= Plat::Role::IAMRole.new(self)
      end
    end
  end
end

Plat::Role.register :cpu, Plat::Role::Cpu
  