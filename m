From: Neil Brown <neilb@suse.de>
Subject: Re: Is It Hopeless?
Date: Mon, 27 Dec 2010 07:33:30 +1100
Message-ID: <20101227073330.6acb577a@notabene.brown>
References: <201012261019.56481.CACook@quantum-sci.com>
	<20101227071156.2371d7d8@notabene.brown>
	<201012261219.41912.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012261219.41912.CACook@quantum-sci.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 26 Dec 2010 12:19:41 -0800 Carl Cook <CACook@quantum-sci.com> wrote:

> 
> My God, it didn't have the command fsck.jfs, so I reinstalled jfsutils.  Now the array mounts.
> 
> I don't understand it.  I thought the JFS driver is in the kernel?

Like many parts of Linux, most of JFS is in the kernel, but some support
tools are separate.   Most filesystems have a separate mkfs.$FSTYPE and
fsck.$FSTYPE.  ALSA (sound subsystem) has alsamixer etc.  md/RAID has mdadm,
nfs has nfs-utils etc etc.  Each of these are primarily kernel subsystems,
but need user-space tools to configure and manage them.

But the important thing is that you have your data back, preparing you for a
Happy New Year!

NeilBrown


> 
> 
> On Sun 26 December 2010 12:11:56 Neil Brown wrote:
> > On Sun, 26 Dec 2010 10:19:55 -0800 Carl Cook <CACook@quantum-sci.com> wrote:
> > 
> > > I went in to turn on my home theater system today, and found a blank screen.  I rebooted and it would not mount /home, which is a 4TB RAID10 array with every movie and show I've recorded over the past two years.  I try to mount it manually, and "wrong fs or bad superblock".  The array is getting set up fine, but the filesystem seems to be destroyed.  
> > > 
> > > Unbelievable.  This isn't supposed to happen.  It happened once before when I wasn't using RAID, but that was the BTRFS filesystem and I blamed it for being pre-release.  But now it's RAID10 with JFS.
> > 
> > None of your logs show anything about jfs....
> > 
> > What does
> >   fsck.jfs /dev/md2
> > report?
> > What about
> >   mount -t jfs /dev/md2 /home
> > 
> > ??
> > 
> > NeilBrown
> > 
> > 
> > > 
> > > The only sign of trouble:
> > > Dec 25 16:14:56 cygnus shutdown[2180]: shutting down for system reboot
> > > Dec 25 16:14:58 cygnus kernel: [16607.840197] md: md2 stopped.
> > > Dec 25 16:14:58 cygnus kernel: [16607.840210] md: unbind<sdb3>
> > > Dec 25 16:14:58 cygnus kernel: [16607.852029] md: export_rdev(sdb3)
> > > Dec 25 16:14:58 cygnus kernel: [16607.852083] md: unbind<sdc3>
> > > Dec 25 16:14:58 cygnus kernel: [16607.864031] md: export_rdev(sdc3)
> > > Dec 25 16:14:58 cygnus kernel: [16607.864092] md2: detected capacity change from 1913403736064 to 0
> > > Dec 25 16:15:00 cygnus kernel: Kernel logging (proc) stopped.
> > > 
> > > Reboot:
> > > Dec 25 16:15:48 cygnus kernel: [    1.156657] Uniform CD-ROM driver Revision: 3.20
> > > Dec 25 16:15:48 cygnus kernel: [    1.464298] md: raid10 personality registered for level 10
> > > Dec 25 16:15:48 cygnus kernel: [    1.469307] md: md2 stopped.
> > > Dec 25 16:15:48 cygnus kernel: [    1.470540] md: bind<sdc3>
> > > Dec 25 16:15:48 cygnus kernel: [    1.470642] md: bind<sdb3>
> > > Dec 25 16:15:48 cygnus kernel: [    1.471381] raid10: raid set md2 active with 2 out of 2 devices
> > > Dec 25 16:15:48 cygnus kernel: [    1.476048] md2: bitmap initialized from disk: read 14/14 pags, set 0 bits
> > > Dec 25 16:15:48 cygnus kernel: [    1.476050] created bitmap (223 pages) for device md2
> > > Dec 25 16:15:48 cygnus kernel: [    1.488465] md2: detected capacity change from 0 to 1913403736064
> > > Dec 25 16:15:48 cygnus kernel: [    1.488942]  md2: unknown partition table
> > > Dec 25 16:15:48 cygnus kernel: [    1.597375] PM: Starting manual resume from disk
> > > Dec 25 16:15:48 cygnus kernel: [    1.650832] kjournald starting.  Commit interval 5 seconds
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

