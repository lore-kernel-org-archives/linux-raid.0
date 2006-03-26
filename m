From: Dan Christensen <jdc@uwo.ca>
Subject: Re: naming of md devices
Date: Sun, 26 Mar 2006 14:34:34 -0500
Message-ID: <87ek0p0zlh.fsf@uwo.ca>
References: <87slpav0p6.fsf@uwo.ca> <87ek0uc595.fsf@hades.wkstn.nix>
	<87fyl9swxb.fsf@uwo.ca> <87hd5nnvd6.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nix <nix@esperi.org.uk> writes:

> On 23 Mar 2006, Dan Christensen moaned:
>
>> I also tried putting root=LABEL=/ on my boot command line.  Debian's
>> kernel seemed to understand this but gave:
>> 
>> Begin: Waiting for root filesystem...
>> Done.
>> Done.
>> Begin: Mounting root filesystem
>> ...kernel autodetection of raid seemed to happen here...
>> ALERT /dev/disk/by_label// does not exist
>
> Ah, welcome to the udev problems. Look at the Debian kernel-maint list
> at lists.debian.org and marvel at the trouble they're having because
> they're using udev on their initramfs. I'm glad I used mdev instead :)

Yes, I'm understanding better what is going on.  First of all, / is
not a valid label.  (The relevant thing for udev is the "safe" output
of "vol_id /dev/md1".)  So I've changed the filesystem label to "root"
using tune2fs -L.

Second, the udev in Debian had support for persistent devices for one
brief release, but it has been taken out while problems with
ide-generic are being investigated.  

I put in my own initramfs hook script to put the appropriate udev
files in the initramfs image, but still I'm not getting the
/dev/disk/by_label/root symlink.  I can't figure out why this
isn't working.

>> BUT, my self-compiled kernel is now failing to bring up the arrays! 
>
> Without boot messages it's very hard to say what's going on. If you have
> another machine, you could try booting with the messages going over a
> serial console...

I may try that, but the stock Debian kernel is working for me so for
now I'll probably leave this unsolved.

Sorry that this is getting a bit off topic for the list.  Thanks
for all the help!

Dan

