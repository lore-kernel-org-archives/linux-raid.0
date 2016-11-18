From: Andy Smith <andy@strugglers.net>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname
 change?
Date: Fri, 18 Nov 2016 03:47:16 +0000
Message-ID: <20161118034716.GI21587@bitfolk.com>
References: <20161117035230.GG21587@bitfolk.com>
 <87lgwihc2v.fsf@notabene.neil.brown.name>
 <20161117150954.GH21587@bitfolk.com>
 <87d1hthgm7.fsf@notabene.neil.brown.name>
 <20161118023144.GC1804@bitfolk.com>
 <87poltfq2d.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87poltfq2d.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I've managed to workaround the issue.

In scrolling back on the serial console to view the early boot
messages and debug logging from udev, I noticed that only sd{a,b}
drives were detected during the initramfs stage. sd{c,d,e,f} were
absent.

This server has two internal flash devices, then the rest of the
drives are on a SAS controller. Evidently the initramfs does not
contain the driver for the SAS controller (mpt3sas). Possibly the
initramfs script correctly deduced that the system could be booted
with only sd{a,b} and did not bother including mpt3sas.

Anyway, I added mpt3sas to /etc/initramfs-tools/modules and rebuilt
the initramfs, and now all drives appear at boot time and all arrays
are assembled:

Begin: Loading essential drivers ... done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... Begin: Assembling all MD arrays ... [   40.1
58317] random: nonblocking pool is initialized
[   40.161795] md: bind<sdf1>
[   40.162161] md: bind<sde1>
[   40.163226] md: raid1 personality registered for level 1
[   40.163654] md/raid1:md0: active with 2 out of 2 mirrors
[   40.163745] md0: detected capacity change from 0 to 510328832
[   40.164259]  md0: unknown partition table
mdadm: /dev/md/0 has been started with 2 drives.
[   40.176662] md: bind<sdf2>
[   40.177235] md: bind<sde2>
[   40.178332] md: raid10 personality registered for level 10
[   40.178656] md/raid10:md1: active with 2 out of 2 devices
[   40.178746] md1: detected capacity change from 0 to 1998585856
[   40.179170]  md1: unknown partition table
mdadm: /dev/md/1 has been started with 2 drives.
[   40.189887] md: md2 stopped.
[   40.191292] md: bind<sdf3>
[   40.191498] md: bind<sde3>
[   40.192705] md/raid10:md2: active with 2 out of 2 devices
[   40.192797] md2: detected capacity change from 0 to 999292928
[   40.193128]  md2: unknown partition table
mdadm: /dev/md/2 has been started with 2 drives.
[   40.204234] md: md3 stopped.
[   40.205278] md: bind<sdf5>
[   40.205695] md: bind<sde5>
[   40.206613] md/raid10:md3: active with 2 out of 2 devices
[   40.206704] md3: detected capacity change from 0 to 12492734464
[   40.207094]  md3: unknown partition table
mdadm: /dev/md/3 has been started with 2 drives.
[   40.218963] md: md5 stopped.
[   40.223807]  sdb: unknown partition table
[   40.228841]  sda: unknown partition table
[   40.229044] md: bind<sda>
[   40.229613] md: bind<sdb>
[   40.234024]  sdb: unknown partition table
[   40.243686] md/raid10:md5: active with 2 out of 2 devices
[   40.243867] created bitmap (14 pages) for device md5
[   40.244684] md5: bitmap initialized from disk: read 1 pages, set 0 of 28614 bits
[   40.245376] md5: detected capacity change from 0 to 1920248840192
[   40.248331]  md5: unknown partition table
mdadm: /dev/md/5 has been started with 2 drives.
Success: assembled all arrays.
done.
[   40.260413] device-mapper: uevent: version 1.0.3
[   40.260540] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
done.
Begin: Running /scripts/local-premount ... [   40.265067] PM: Starting manual resume from disk
done.
Begin: Will now check root file system ... fsck from util-linux 2.25.2
[/sbin/fsck.ext4 (1) -- /dev/md1] fsck.ext4 -a -C0 /dev/md1
root: clean, 44775/122160 files, 265568/487936 blocks
done.
[   40.296866] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
done.
Begin: Running /scripts/local-bottom ... done.
Begin: Running /scripts/init-bottom ... done.
[   40.350701] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCR
YPT +ACL +XZ -SECCOMP -APPARMOR)
[   40.350843] systemd[1]: Detected virtualization 'xen'.
[   40.350920] systemd[1]: Detected architecture 'x86-64'.

Welcome to Debian GNU/Linux 8 (jessie)!

Am I right in thinking this is not incremental assembly by udev, but
kernel auto-assembly?

Also, in the previous configuration, mpt3sas was being loaded once
the root filesystem had been mounted. All the drives on the SAS
controller were then available, so udev should have assembled md5 at
that point, right? So I think there is still a problem here, just
one which I have worked around in some other way.

If that is the case, would you like me to continue debugging udev?

Cheers,
Andy
