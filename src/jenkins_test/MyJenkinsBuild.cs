using System;
using System.Diagnostics;

namespace jenkins_test
{
    public class MyJenkinsBuild
    {
        public MyJenkinsBuild(int portNumber = 0)
        {
            PortNumber = portNumber > 0 ? portNumber : throw new ArgumentException($"{nameof(portNumber)} not specified");
        }

        public int PortNumber { get; }

        public void MyFunctionThatIsNotCovered()
        {
            if (1 == 1)
            {
                Debug.Write("You just called my awesome function");
            }


            if (1 == 2)
            {
                try
                {
                    throw new Exception("test");
                }
                catch (Exception ex)
                {
                    throw;
                }
            }
        }
    }
}
