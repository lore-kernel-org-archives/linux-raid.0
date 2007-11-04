From: Robin Lee Powell <rlpowell@digitalkingdom.org>
Subject: Double mdadm --monitor == hang
Date: Sun, 4 Nov 2007 13:10:37 -0800
Message-ID: <20071104211037.GA7410@digitalkingdom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Please cc me on replies; I'm not on the list.

I don't know if this is fixable, or even if it *should* be fixed,
but: summary: shortly after the state of the machine is "2
independent mdadm --monitor instances, resyncing", the
machine totally locks up.  Details follow.

I boot my machine from a USB stick, because the hard drive is
encrypted.  The start up goes something like this:

    mdadm --assemble /dev/md_d0 /dev/sda /dev/sdb /dev/sdc /dev/sdd

    losetup ... /dev/loop0 /dev/md_d0p2

    /bin/mount -o rw -n /dev/loop0 /mnt

    cd /mnt

    /sbin/pivot_root . usb_boot

    exec chroot . /sbin/init $* </dev/console >/dev/console 2>&1

Before it does all that, though, it starts up mdadm --monitor,
because it's got the Debian mdadm package installed, and that's how
that works.

Then in re-runs init after the pivot_root.  The OS on /dev/md_d0p2
also has the Debian mdadm package install, so it also starts mdadm
--monitor.  The two instances have no real way to see each other.

This works fine until a resync is needed; shortly after the state of
the machine is "2 mdadm --monitor instances, resyncing", the machine
totally locks up.

Solved by not starting mdadm --monitor on the USB stick, obviously,
but it took quite a while to figure out.  :(

-Robin

-- 
Lojban Reason #17: http://en.wikipedia.org/wiki/Buffalo_buffalo
Proud Supporter of the Singularity Institute - http://singinst.org/
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
