From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Grub vs Lilo
Date: Wed, 26 Jul 2006 23:58:28 +0400
Message-ID: <44C7C964.5030705@tls.msk.ru>
References: <200607261943.24828.mylists@blue-matrix.org> <ea865p$7o0$1@sea.gmane.org> <44C7ADA6.7020200@tls.msk.ru> <44C7BB7B.4010001@rhm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C7BB7B.4010001@rhm.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Rieke <bernd@rhm.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bernd Rieke wrote:
> Michael Tokarev wrote on 26.07.2006 20:00:
> .....
> .....
>>The thing with all this "my RAID devices works, it is really simple!" thing is:
>>for too many people it indeed works, so they think it's good and correct way.
>>But it works up to the actual failure, which, in most setups, isn't tested.
>>But once something failed, umm... Jason, try to remove your hda (pretend it
>>is failed) and boot off hdc to see what I mean ;) (Well yes, rescue disk will
>>help in that case... hopefully. But not RAID, which, when installed properly,
>>will really make disk failure transparent).
>>/mjt
> 
> Yes Michael, your right. We use a simple RAID1 config with swap and  / on
> three SCSI-disks (2 working, one hot-spare) on SuSE 9.3 systems. We had to
> use lilo to handle the boot off of any of the two (three) disks. But we had
> problems over problems until lilo 22.7 came up. With this version of lilo
> we can pull off any disk in any scenario. The box boots in any case.

Well, alot of systems here works on root-on-raid1 with lilo-2.2.4 (Debian
package), and grub.  By "works" I mean they really works, ie, any disk
failure don't prevent the system from working and (re)booting flawlessly
(provided the disk is really dead, as opposed to when it is present but
fails to read (some) data - in which case the only way is either to remove
it physically or to choose another boot device in BIOS.  But that's
entirely different story, about (non-existed) "really smart" boot loader
I mentioned in my previous email).

The trick is to set the system up "properly".  Simple/obvious way
(installing grub to hda1 and hdc1) don't work when you remove hda, but
"complex" way works.

More, I'd not let LILO to do more guesswork for me (like raid-extra-boot
stuff, or whatever comes with 22.7 - to be honest, I didn't look at it
at all, as debian package of 2.2.4 (or 22.4?) works for me just fine).
Just write the damn thing into the start of mdN (and let raid code to
replicate it to all drives, regardless of how many of them there is),
after realizing it's really a partition number X (with offset Y) on a
real disk, and use bios code 0x80 for all disk access.  That's all.
The rest - like ensuring all the (boot) partitions are at the same
place on every disk, that disk geometry is the same etc - is my duty,
and this duty is done by me accurately - because I want the disks to
be interchangeable.

> We were wondering when we asked the groups while in trouble with lilo
> before 22.7 not having any response. Ok, the RAID-Driver and the kernel
> worked fine while resyncing the spare in case of a disk failure (thanks to
> Neil Brown for that). But if a box had to be rebooted with a failed disk
> the situation became worse. And you have to reboot because hotplug still
> doesn't work. But nobody seems to care abou or nobody apart of us has
> these problems  ...

Just curious - when/where you asked?
[]
> So we came to the conclusion that everybody is working on RAID but nobody
> cares about the things around, just as you mentioned, thanks for that.

I tend to disagree.  My statement above refers to "simple advise" sometimes
given here and elsewhere, "do this and that, it worked for me".  By users
who didn't do their homework, who never tested the stuff, who, sometimes,
just has no idea as of HOW to test (it's not an insulting statement
hopefully - I don't blame them for their lack of knowlege, it's something
which isn't really cheap, after all).  Majority of users are of this sort,
and they follow each other's advises, again, without testing.  HOWTOs
written by such users, as well (as someone mentioned to me in private
email as a response to my reply).

I mean, the existing software works.  It really works.  The only thing left
is to set it up correctly.

And please PLEASE don't treat it all as blames to "bad" users.  It's not.
I learned this stuff the hard way too.  After having unbootable remote
machines after a disk failure, when everything seemed to be ok.  After
screwing up systems using famous "linux raid autodetect" stuff everyone
loves, when, after replacing a failed disk to another, which -- bad me --
was a part of another raid array on another system, and the box choosen
to assemble THAT raid array instead of this box's one, and overwritten
good disk with data from new disk which was in a testing machine.  And
so on.  That all to say: it's easy to make a mistake, and treating the
resulting setup as a good one, until shit start happening.  But shit
happens very rarely, compared to "average system usage", so you may never
know at all that your setup is wrong, and ofcourse you will tell how
to do things to others... :)

/mjt
