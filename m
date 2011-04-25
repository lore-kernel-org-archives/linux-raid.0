From: David Brown <david.brown@hesbynett.no>
Subject: Re: Direct disk access on IBM Server
Date: Mon, 25 Apr 2011 11:42:56 +0200
Message-ID: <ip3fn1$eo6$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org> <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com> <iop4s2$cjp$1@dough.gmane.org> <BANLkTi=SRxoMjpEHeS48eJBCt3qY8CMYqQ@mail.gmail.com> <ip1vgg$7e0$1@dough.gmane.org> <4DB4872A.4030900@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB4872A.4030900@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/04/11 22:25, Rudy Zijlstra wrote:
> On 04/24/2011 10:00 PM, David Brown wrote:
>>
>>
>> But there is also no doubt that the MegaCli command line tool is
>> absolutely terrible in comparison to mdadm. It is downright
>> user-unfriendly. I haven't bothered with the LSI gui tools - they are
>> useless on a server, where there is no place for X. The "webbios" bios
>> setup is okay, but only available when rebooting the machine - it's
>> fine for the initial setup. So the only real tool that will work over
>> a ssh session while the system is running, is MegaCli. Since it is
>> statically linked it works with any system, which is nice. But the
>> interface is painfully unclear, sadistically inconsistent, and badly
>> documented. If an emergency situation arose, I could explain mdadm and
>> dictate commands over the phone to a backup admin - there's not a
>> chance I could do that with MegaCli.
>>
> You can run the GUI on a different machine then the raid is on. The SW
> contains a "server" app and the X client side. The server app needs to
> run on the actual server, the GUI can run on any network connected machine.
>

I may not have read all the information correctly, but it seemed to me 
that I had the choice of installing the client only, or everything - 
meaning installing the gui client on the server as well.  Maybe I'll 
give it a try at some point.

However, realistically speaking I hope and expect that I won't need to 
do much with the raid anyway.  It's set up, and the chances are that it 
will continue to run for years without problems.  My aim with MegaCli 
was that I would be able to handle something like a disk replacement, or 
perhaps growing the raid, without taking the server offline during the 
whole process (I don't mind a reboot or two, as long as the rebuild 
itself can run while the server is online).  So MegaCli is good enough 
for that.

I guess it just struck me as strange that MegaCli is so awkward.  A 
quick google search shows I am not alone - others describe it as "the 
most cryptic command line utility in existence" (I wouldn't go that 
far), and that MegaRAID Storage Manager is a "java based monster that 
nobody really wants to have on a server".  The card itself is fine - and 
I've heard nothing but good opinions of it.  Surely a company that can 
make such good cards could make better software to let admins work with 
them in the way they want?


