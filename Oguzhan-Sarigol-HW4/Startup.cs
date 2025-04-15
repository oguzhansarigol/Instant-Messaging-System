using Microsoft.Owin;
using Owin;
using Microsoft.AspNet.SignalR;

[assembly: OwinStartup(typeof(Oguzhan_Sarigol_HW4.Startup))]

namespace Oguzhan_Sarigol_HW4
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // SignalR’a kullanıcı kimliğini nasıl bulacağını öğretiyoruz
            GlobalHost.DependencyResolver.Register(typeof(IUserIdProvider), () => new CustomUserIdProvider());

            app.MapSignalR();
        }
    }
}
