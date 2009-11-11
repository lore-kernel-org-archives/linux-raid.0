From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Tue, 10 Nov 2009 21:34:09 -0600
Message-ID: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
References: <4AF9ABAA.1020407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9ABAA.1020407@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> >> Notice that bring up all raids normally happens before mount
> >> filesystems.  So, with your bitmaps on a partition that likely isn't
> >> mounted when the raids are brought up, how would it ever work?
> >
> > 	It's possible it never has, since as I say I don't ordinarily reboot
> > these systems.  How can I work around this?  As you can see from my
> original
> > post, the boot and root file systems are reiserfs, and we are cautioned
> not
> > to put the bitmap on anything other than an ext2 or ext3 file system,
> which
> > is why I created the small /dev/hd4 partition.
> 
> Sure, that makes sense, but given that usually filesystems are on raid
> devices and not the other way around, it makes sense that the raids are
> brought up first ;-)

	I see your point.  It's certainly a simpler approach.

> > 	I suppose I could put a script in /etc/init.d et al in order to grow
> > the array with a bitmap every time the system boots, but that's clumsy,
> and
> > I could imagine it could create a problem if the array ever comes up
> > unclean.
> >
> > 	I guess I could also drop to nunlevel 0, wipe the root partition,
> > recreate it as an ext3, and copy all the files back, but I don't relish
> the
> > idea.  Is there any way to convert a reiserfs partition to an ext3 on
> the
> > fly?
> >
> > 	Oh, and just BTW, Debian does not employ rc.sysinit.
> 
> I don't grok debian unfortunately :-(  However, short of essentially
> going in an hand editing the startup files to either A) mount the bitmap
> mount early or B) both start and mount md0 late, you won't get it to
> work.

	Well, it's supposed to be pretty simple, but I just ran across
something very odd.  Instead of using an rc.sysinit file, Debian maintains a
directory in /etc for each runlevel named rcN.d, where N is the runlevel,
plus one named rcS.d and a file named rc.local.  The rc.local is run after
exiting any multi-user runlevel, and normally does nothing but quit with an
exit code of 0.  Generally, the files in the rcN.d and rcS.d directories are
all just symlinks to scripts in /etc/init.d.  The convention is the link
names are of the form Sxxyyyy or Kxxyyyy, where xx is a number between 01
and 99 and yyyy is just some mnemonic text.  Any link with a leading "K" is
taken to be disabled and is thus ignored by the system

	The scripts in rcS.d are executed during a system boot, before
entering any runlevel, including a single user runlevel.  In addition to
running everything in rcS.d at boot time, whenever entering runlevel N, all
the files in rcN.d are executed.  Each file is executed in order by its
name.  Thus, all the S01 - S10 scripts are run before S20, etc.  By the time
any S40xxx script runs in rcS.d, all the local file systems should be
mounted, networking should be available, and all device drivers should be
initialized.  By the time any S60xxx script is run, the system clock should
be set, any NFS file systems should be mounted (unless they depend upon the
automounter), and any file system cleaning should be done.  The first RAID
script in rcS.d is S25mdadm-raid and the first call to the mount script is
S35mountall.sh.  Thus, as you say, the RAID systems are loaded before the
system attempts to mount anything other than /.  The default runlevel in
Debian is 2, so during ordinary booting, everything in rcS.d should run
followed by everything in rc2.d.

	Here's what's weird, and it can't really be correct... I don't
think.  In both rcS.d and rc2.d (and no doubt others), there are two
scripts:

RAID-Server:/etc# ll rcS.d/*md*
lrwxrwxrwx 1 root root 20 2008-11-21 22:35 rcS.d/S25mdadm-raid ->
../init.d/mdadm-raid
lrwxrwxrwx 1 root root 20 2008-12-27 18:35 rcS.d/S99mdadm_monitor ->
../init.d/mdadm-raid
RAID-Server:/etc# ll rc2.d/*md*
lrwxrwxrwx 1 root root 15 2008-11-21 22:35 rc2.d/S25mdadm -> ../init.d/mdadm
lrwxrwxrwx 1 root root 20 2008-12-27 18:36 rc2.d/S99mdadm_monitor ->
../init.d/mdadm-raid

	Note both S99mdadm_monitor links point to /etc/init.d/mdadm-raid,
and so does the S25mdadm-raid script in rc2.d, while the /etc/rc2.d/S25mdadm
script points to /etc/init.d/mdadm.  The mdadm-raid script starts up the
RAID process, and the mdadm script runs the monitor.  It seems to me the
only link which is really correct is the rcS.d/S25mdadm.  At the very least
I would think both the S99mdadm_monitor links should point to init.d/mdadm
(which, after all is the script which starts the monitor) and that
rc2.d/S25mdadm-raid would point to init.d/mdadm, just as the
rcS.d/S25mdadm-raid link does.  Of course, since the RAID startup script
does get called before any of the others, and since the script only shuts
down RAID for runlevel 0 (halt) or runlevel 6 (reboot) and not for runlevel
1 - 5 or S, it still works OK, but I don't think it's really correct.  Can
someone else comment?

	Getting back to my dilema, however, I suppose I could simply create
an /etc/rcS.d/S24mounthda4 script that explicitly mounts /dev/hda4 to
/etc/mdadm/bitmap, or I could modify the init.d/mdadm-raid script to
explicitly mount the /dev/hda partition if it is not already mounted.
Editing the init.d/mdadm-raid script is a bit cleaner and perhaps clearer,
but any update to mdadm is liable to wipe out the modifications to the
startup script.

>  If the array isn't super performance critical, I would use mdadm
> to delete the bitmap, then grow an internal bitmap with a nice high
> chunk size and just go from there.  It can't be worse than what you've
> got going on now.

	I really dislike that option.  Doing it manually every time I boot
would be a pain.  Writing a script to do it automatically is no more trouble
(or really much different) than writing a script to mount the partition
explicitly prior to running mdadm, but it avoids any issues of which I am
unaware (but can imagine) with, say, trying to grow a bitmap on an array
that is other than clean.  I'd rather have mdadm take care of such details.

	What do you (and the other memebers of the list) think?

