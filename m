From: Roger Ellison <raennnn@adelphia.net>
Subject: Re: Debian Sarge mdadm raid 10 assembling at boot problem
Date: Wed, 05 Jan 2005 14:15:49 -0500
Message-ID: <1104952549.929.68.camel@rae.home>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg>
	 <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es>
	 <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es>
	 <20050102194240.GE99565@caffreys.strugglers.net>
	 <5h1ma2-asq.ln1@news.it.uc3m.es>
	 <20050103003005.GG99565@caffreys.strugglers.net>
	 <2rana2-0if.ln1@news.it.uc3m.es> <41D93657.7090908@tls.msk.ru>
	 <a41oa2-fr7.ln1@news.it.uc3m.es> <1104904239.1613.26.camel@rae.home>
	 <41DBEE70.3080505@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DBEE70.3080505@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-01-05 at 08:41, Michael Tokarev wrote:
> [Please don't start new thread by replying to another message.]
> 
> Roger Ellison wrote:
> > I've been having an enjoyable time tinkering with software raid with
> > Sarge and the RC2 installer.  The system boots fine with Raid 1 for
> > /boot and Raid 5 for /.  I decided to experiment with Raid 10 for /opt
> > since there's nothing there to destroy :).  Using mdadm to create a Raid
> > 0 array from two Raid 1 arrays was simple enough, but getting the Raid
> 
> Note there's special raid10 module in recent kernels (and supported by
> recent mdadm).  I don't think it's very stable yet, but.. JFYI ;)

I didn't see Raid 10 mentioned in the mdadm man page.  Do you have the
command line syntax handy?  I don't have access to the machine now, but
I believe it's mdadm version 1.7 (from August '04).
> 
> > 10 array activated at boot isn't working well.  I used update-rc.d to
> > add the symlinks to mdadm-raid using the defaults, but the Raid 10 array
> 
> Shouldn't the links be made automatically when installing mdadm?
> Also, make sure you're using recent debian package of mdadm --
> earlier versions was.. with issues concerning assembling the
> arrays (a problem specific to debian mdadm-raid scripts).
> Make sure AUTOSTART is set to true in /etc/default/mdadm
> (I'm not sure if that's really `AUTOSTART' and `true',
> you can look at the file and/or use dpkg-reconfigure mdadm
> to set that).
> 
The symlinks on Sarge installation were:
	rc0.d -->  S50mdadm-raid
	rc6.d -->  S50mdadm-raid	
	rcS.d -->  S25mdadm-raid
I removed them before running 'update-rc.d'.
> > isn't assembled at boot time.  After getting kicked to a root shell, if
> > I check /proc/mdstat only md1 (/) is started.  After running mdadm-raid
> > start, md0 (/boot), md2, and md3 start.  If I run mdadm-raid start again
> > md4 (/opt) starts.  Fsck'ing the newly assembled arrays before
> > successfully issuing 'mount -a' shows no filesystem errors.  I'm at a
> > loss and haven't found any similar issue mentions on this list or the
> > debian-users list.  Here's mdadm.conf:
> 
> You have two problems.
> First of all, mdadm-raid should be started at very early in the
> boot process, and mdadm package post-install scripts ensures this
> (you added mdadm-raid links at default order which is 20; but
> it should run before filesystem mounts etc, nearly 01 or something).
> Ditto for stop scripts -- at the very end, after umounting the
> filesystems.  Take a look at /var/lib/dpkg/info/mdadm.postinst --
> it sets up the links properly.  When you correct this, your system
> will go further in boot process... ;)
> 
> And second problem is the order of lines in mdadm.conf.
> 
> [edited a bit]
> > DEVICE partitions
> > DEVICE /dev/md*
> > ARRAY /dev/md4 level=raid0 num-devices=2  devices=/dev/md2,/dev/md3
> > ARRAY /dev/md3 level=raid1 num-devices=2  devices=/dev/sdb5,/dev/sde5
> > ARRAY /dev/md2 level=raid1 num-devices=2  devices=/dev/sda5,/dev/sdc5
> 
> Re-order the lines so that md4 will be listed AFTER all it's
> components.  Mdadm tries to assemble them in turn as they're
> listed in mdadm.conf. But at the time when it tries to start
> md4, it's components aren't here yet so it fails.
> 
Reordering the ARRAY entries has no effect.  'mdadm-raid start' has to
be run twice, same as before.  Changing the start symlinks from '20' to
'13' (just after syslogd) doesn't help. (sigh).  
> HTH.
> 
> /mjt
> -
Roger

