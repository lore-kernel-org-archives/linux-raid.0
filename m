From: NeilBrown <neilb@suse.de>
Subject: Re: Question on md126 / md127 issues
Date: Sat, 28 May 2011 07:36:02 +1000
Message-ID: <20110528073602.128cebc0@notabene.brown>
References: <BANLkTinePbV0qfs5XXy9cZQ2a7bQfO=FVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinePbV0qfs5XXy9cZQ2a7bQfO=FVQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 May 2011 00:10:35 -0400 Dylan Distasio <interzone@gmail.com> wrote:

> Hi all-
> 
> I recently created a RAID1 2 disk mdadm array /dev/md1 with 1.2
> metadata on a Ubuntu system that has 3 other mdadm arrays running on
> it.  The power went out at my house last night, and I rebooted the
> system when it came back up.
> 
> When it came back up, my new array was in two pieces /dev/md126 and
> /dev/md127 (with incorrect members, showing 1 active drive, 1 spare in
> each).   I rebooted again, and had what appeared to be my working
> array, but showing up under /dev/md127.  I could stop and do a --scan
> to assemble it correctly as /dev/md1, but when I rebooted again I got
> the same results with 126 and 127.  My mdadm.conf was correct.

Very weird.  It sounds like mdadm in the initrd is running before all devices
have been discovered, but even that shouldn't create two arrays....

Maybe the second device gets discovered after the switch to a real root and
something gets lost..


> 
> I did some searching on my archives of this list, and found a solution
> as follows:
> -----------
> How to fix the '125/126/127' mdadm issue.
> 
> The array has '125' stored as the 'preferred minor' in the metadata.

1.2 metadata doesn't have a 'perferred minor' - only 0.90 has that.

1.2 has a 'name' which has a vaguely similar purpose but I don't think it
would cause this sort of issue.  I would be very surprised if '125' ever got
stored there unless you explicitly asked for it.

> You can change this by assembling with --update=super-minor.
> e.g.
> 
>  mdadm -S /dev/md125
>  mdadm -A /dev/md1 --update=super-minor

This command will not affect a 1.2 array at all.  It will just assemble it.

> 
> it should get details of which devices to included from /etc/mdadm.conf.
> 
> However it is possible that mdadm.conf in your initrd also the name
> as /dev/md125.
> So once you have performed the above, run mkinitrd again, reboot, and report
> what happens.
> ----------------

Running mkinitrd when you have boot problems is always a good idea.  Maybe
that was all it took to fix your problem ??


> 
> I had to run the above commands, and then make sure I ran
> update-initramfs -v -u for it to stick after reboot.
> 
> My issue is solved, but I would like to understand what the root cause
> is, and why the above solution worked.  Can someone elaborate on what
> super-minor is?  This is a home system and I had backups so I was
> comfortable trying the above, but I don't typically like running
> commands on faith I don't understand fully, especially in Linux.
> 
> Can anyone shed some light on this?  I can provide further OS and
> array details if necessary, but it sounds like this issue has occurred
> for others in the past.

Now that the problem is fixed it is very hard to figure out what was happening
before.  My best guess is that someone was wrong with mdadm.conf in the
initrd, but I don't know what.

NeilBrown

