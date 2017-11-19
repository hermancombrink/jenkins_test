using System;
using FluentAssertions;
using jenkins_test;
using Xunit;

namespace jenkins_test_unittests
{
    public class MyJenkinsBuild_UnitTest
    {
        [Fact]
        public void JenkinsBuildWithNoPortShouldThrow()
        {
            Action act = () => {

                new MyJenkinsBuild(0);
            };

            act.ShouldThrow<ArgumentException>();
        }

        [Fact]
        public void JenkinsBuildWithPortShouldSuccess()
        {
            Action act = () => {

                new MyJenkinsBuild(2);
            };

            act.ShouldNotThrow<ArgumentException>();
        }

        [Fact]
        public void CallingJenkingBuildShouldPass()
        {
            Action act = () => {

                new MyJenkinsBuild(2).MyFunctionThatIsNotCovered(); 
            };

            act.ShouldNotThrow<ArgumentException>();
        }

    }
}
