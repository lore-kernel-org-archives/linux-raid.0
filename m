From: Maarten J H van den Berg <maarten@vbvb.nl>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Thu, 4 Mar 2004 03:08:50 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403040308.50652.maarten@vbvb.nl>
References: <404532F6.8743.303008B@localhost> <40460DC4.10744.659B232@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40460DC4.10744.659B232@localhost>
Content-Disposition: inline
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Chris.

Just a few points and musings...  may be helpful, may be not...

On Wednesday 03 March 2004 17:54, Chris Evans wrote:
> I thought I'd got this all cracked in the early hours of this
> morning.  I _think_ I'd been putting boot=/dev/hda1 when I tried to
> write the revised lilo config to the MBR and perhaps that messed up
> hdb.  I don't know, anyway, I started again, did everything in that
> howto pretty much to the letter and this time, after shifting boot to
> /dev/hdc and rebooting, I could add /dev/hdb1.  However, lilo would
> not let me use a raid-extra-boot line and when I rebooted, the system
> hung right at the start.

Yeah I forgot to remind you to change hda [my setup] to hdb [yours].

I may have a partial solution for you...  I tend to have BIG problems booting 
off anything but the first BIOS drive, maybe that's lilo, maybe that me not 
fully understanding lilo (or maybe a BIOS issue even).  In any case, this 
leads to me _always_ having hda as bootdisk. So, when I built my raid0 sets I 
think I might have done it thusly:

(1) Install your OS on hda
Define raidtab: hda=failed-disk hdc=raid-disk; activate raid, format, cp data
Mount /dev/md0 /mnt
Change ONLY the fstab and lilo.conf on the mounted /dev/md0 volume:
	tell fstab to find / as /dev/md0
	tell lilo.conf to boot off /dev/hda (!hdA! not hdc nor md0)
Now when I would run 'lilo -r /mnt' it will complain "not on the first disk" 
or something like that...  So instead, I do:
Down system; swap over hda with hdc; boot (keep a bootfloppy around!!)
run lilo (which must / should work now without complaining)
add the (now free) hdc (which used to be hda) to your raid volume.
(3) Profit !  ;-)

I know, its a hassle, but maybe this does help you a bit though.


Another possibility, but which requires changing your partitions:

After some problems I decided it was simpler to just work around lilo problems 
by having a separate tiny non-raid /boot partition[*]. This has its drawbacks 
but it solves the lilo issues.  The downside is that you must manually 
mirror /dev/hda1 to /dev/hdc1 [typically using dd], (also after a kernel 
upgrade!) and that when disk hda fails it will NOT boot from hdc by itself 
(it requires an admin with a boot/rescuefloppy physically at the console). 
If (big IF) you can live with that you may want to try it but be warned that 
it is somewhat of an ugly hack...

[*] Note: I did this partly for raid but also partly for reiserfs. I thought 
it prudent to have a plain old ext2 /boot partition with the full kernel as 
opposed to needing an initrd with reiser support on a single reiserfs 
partition. YMMV...

> I moved hdb1 to hda1 and started again, this time it's all worked
> except for boot=/dev/md0 and the raid-extra-boot.  Now lilo allows
> these and says it's written to both MBRs, but when I reboot lilo gets
> to the first twenty or so of the dots after "Loading Linux" and hangs
> there ... resolutely.

Weird...  I have never seen that. "LI" and "LIL" errors, yeah, but not that.

> A lot of pratting around with rescuing from the installation CD (must
> work out how to burn a rescue boot CDROM) and I am back to being able
> to get everything find if I boot from boot=/dev/hdc with
> root=/dev/md0 ... and I think I'll give up here as I must go back to
> doing my real job and having a life.  If anyone can tell me what
> might be neeeded (I haven't tried things like bios=0x80 lines) I may

Hmm. Bugger...  I'm no lilo expert (far from it in fact) but my understanding 
is / was that especially these lines are ESSENTIAL...! 
Why did you omit these lines...  They are there for a reason.

I hope you do find a solution...  good luck!

Maarten

