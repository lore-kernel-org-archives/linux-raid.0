From: "Chris Evans" <chris1@psyctc.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 16:54:28 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40460DC4.10744.659B232@localhost>
References: <404532F6.8743.303008B@localhost>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200403030336.51772.maarten@vbvb.nl>
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I thought I'd got this all cracked in the early hours of this 
morning.  I _think_ I'd been putting boot=/dev/hda1 when I tried to 
write the revised lilo config to the MBR and perhaps that messed up 
hdb.  I don't know, anyway, I started again, did everything in that 
howto pretty much to the letter and this time, after shifting boot to 
/dev/hdc and rebooting, I could add /dev/hdb1.  However, lilo would 
not let me use a raid-extra-boot line and when I rebooted, the system 
hung right at the start.

I moved hdb1 to hda1 and started again, this time it's all worked 
except for boot=/dev/md0 and the raid-extra-boot.  Now lilo allows 
these and says it's written to both MBRs, but when I reboot lilo gets 
to the first twenty or so of the dots after "Loading Linux" and hangs 
there ... resolutely.  

A lot of pratting around with rescuing from the installation CD (must 
work out how to burn a rescue boot CDROM) and I am back to being able 
to get everything find if I boot from boot=/dev/hdc with 
root=/dev/md0 ... and I think I'll give up here as I must go back to 
doing my real job and having a life.  If anyone can tell me what 
might be neeeded (I haven't tried things like bios=0x80 lines) I may 
find the energy to try them but not if this machine has become my 
working firewall!

So I'm left thinking there's something, perhaps idiosyncratic to some 
BIOS or HDs or whatever, that means some of us have real problems 
writing LILO boot instructions to the two drives in a RAID1 boot 
array.

I've leflt Maarten's listing of a SuSE lilo.conf to see if anyone has 
ideas.

Thank everyone,

Chris

> Neil had some interesting points, but in the meantime here's my
> working lilo.conf (which was written by the SuSE installer) in case it
> helps you:
> 
> boot = /dev/hda
> change-rules
>     reset
> default = linux
> disk=/dev/hda
>     bios=0x80
>     disk=/dev/hdc
>     bios=0x81
> lba32
> prompt
> read-only
> timeout = 80
> 
> image = /boot/vmlinuz
>     label = linux
>     initrd = /boot/initrd
>     root = /dev/md0
> 
> 
> Greetings,
> Maarten
> 
> 
> -- 
> To UNSUBSCRIBE, email to debian-user-request@lists.debian.org 
> with a subject of "unsubscribe". Trouble? Contact
> listmaster@lists.debian.org
> 

PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
   and Therapeutic Communities; practice, research, 
   teaching and consultancy.
Chris Evans & Jo-anne Carlyle
http://psyctc.org/ Email: chris@psyctc.org

