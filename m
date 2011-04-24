From: David Brown <david.brown@hesbynett.no>
Subject: Re: Direct disk access on IBM Server
Date: Sun, 24 Apr 2011 22:00:16 +0200
Message-ID: <ip1vgg$7e0$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org> <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com> <iop4s2$cjp$1@dough.gmane.org> <BANLkTi=SRxoMjpEHeS48eJBCt3qY8CMYqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=SRxoMjpEHeS48eJBCt3qY8CMYqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/04/11 14:48, Drew wrote:
> Hi David,
>
>> My goal here is to understand my options before deciding.  I've had a bit of
>> space between getting the machine and actually having the time to put it
>> into service, so I've tested a bit and thought a bit and discussed a bit on
>> this mailing list.  I'll probably go for hardware raid5 - which I could have
>> done in the beginning.  But now I know more about why that's the sensible
>> choice.
>
> I'm going to jump in a bit late but as an owner of several of these
> little beasts and say this. You have a skookum RAID card on there so
> use it. :) I'd also *strongly* recommend you jump for the BBU
> (Battery) if you haven't already.
>
> This hasn't been mentioned as a consideration but one more point of
> going in favor with the HW RAID is this: You're away on vacation and a
> drive dies. Your backup admin notices and calls an IBM monkey out to
> replace the drive. He goes, finds the failed drive indicated by the
> little warning light, and replaces it. You get back to find a zero
> dollar service order on your desk. :-)
>

Yes, I understand the point about ease of maintenance for others - 
that's already an issue for us, as I'm the only one who really 
understands the systems we have.  Of course, buying a hot-spare drive 
will involve even less effort for the backup admin, and I'll probably do 
that.

> I don't know about your shop but that's how it'd play out in mine.
> mdadm is a great product no doubt, but to work effectively with it
> everyone involved has to understand it. If you're a one man show like
> I am, with vendors who don't really touch linux (not as much money in
> it vs M$), making your linux systems as foolproof as possible is
> important, especially when the bosses are somewhat biased against it.
>

My vendor here does use Linux, but not in the way /I/ do.  It's a 
disadvantage of the flexibility and choice in the Linux world.  (I have 
no problem with the boss regarding Linux - it would cost more money just 
to figure out what MS software and client licenses we would need than it 
cost us to buy the Linux hardware.)

I've set up the system now with hardware raid5.  I've used MegaCli to 
monitor and test the system, and grow it online by adding another drive. 
  There is no doubt that the hardware raid card works, and it's fast, 
and the little lights on the drives are a great idea.

But there is also no doubt that the MegaCli command line tool is 
absolutely terrible in comparison to mdadm.  It is downright 
user-unfriendly.  I haven't bothered with the LSI gui tools - they are 
useless on a server, where there is no place for X.  The "webbios" bios 
setup is okay, but only available when rebooting the machine - it's fine 
for the initial setup.  So the only real tool that will work over a ssh 
session while the system is running, is MegaCli.  Since it is statically 
linked it works with any system, which is nice.  But the interface is 
painfully unclear, sadistically inconsistent, and badly documented.  If 
an emergency situation arose, I could explain mdadm and dictate commands 
over the phone to a backup admin - there's not a chance I could do that 
with MegaCli.

Overall, with the server I have which came with the LSI card and no 
clear way to get direct access to the disks, then using the hardware 
raid is my best option.  But for future purchases I would think very 
hard before spending money on the same solution (for the same usage) - 
I'd be inclined to spend the money on more disks than on the raid card.


