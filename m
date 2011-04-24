From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Direct disk access on IBM Server
Date: Sun, 24 Apr 2011 22:25:14 +0200
Message-ID: <4DB4872A.4030900@grumpydevil.homelinux.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org> <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com> <iop4s2$cjp$1@dough.gmane.org> <BANLkTi=SRxoMjpEHeS48eJBCt3qY8CMYqQ@mail.gmail.com> <ip1vgg$7e0$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ip1vgg$7e0$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2011 10:00 PM, David Brown wrote:
>
>
> But there is also no doubt that the MegaCli command line tool is 
> absolutely terrible in comparison to mdadm.  It is downright 
> user-unfriendly.  I haven't bothered with the LSI gui tools - they are 
> useless on a server, where there is no place for X.  The "webbios" 
> bios setup is okay, but only available when rebooting the machine - 
> it's fine for the initial setup.  So the only real tool that will work 
> over a ssh session while the system is running, is MegaCli.  Since it 
> is statically linked it works with any system, which is nice.  But the 
> interface is painfully unclear, sadistically inconsistent, and badly 
> documented.  If an emergency situation arose, I could explain mdadm 
> and dictate commands over the phone to a backup admin - there's not a 
> chance I could do that with MegaCli.
>
You can run the GUI on  a different machine then the raid is on. The SW 
contains a "server" app and the X client side. The server app needs to 
run on the actual server, the GUI can run on any network connected machine.

Cheers,


Rudy
