From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: replaced disk in RAID1 imsi array - how to activate?
Date: Thu, 9 Aug 2012 15:42:06 +0200
Message-ID: <20120809134201.GA14931@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Setup: kernel 3.2.21 (debian testing), mdadm 3.2.5.

I created a RAID1 imsi array on a supermicro server for testing
purposes. I'm trying to see what happens if I hot-remove disks,
hot-add them, reboot, etc to test the resiliency of this setup.

So I removed (by pulling it out) one disk, then simulated adding
a blank replacement disk by putting it back in and running
mdadm --zero-superblock on it.

I re-added it to the container with mdadm /dev/md127 --add /dev/sda..
and now it just sits there. How do I get the RAID1 array (dev/md126)
to start using this disk? The manpage says:

       -a, --add
              hot-add  listed  devices.  If a device appears to have re=
cently
              been part of the array (possibly it failed or was removed=
)  the
              device  is  re-added  as  described in the next point.  I=
f that
              fails or the device was never part of the array, the devi=
ce  is
              added  as a hot-spare.  If the array is degraded, it will=
 imme=E2=80=90
              diately start to rebuild data onto that spare.

However, nothing is happening:

root@server3-b05-tpb:~/tmp# cat /proc/mdstat
Personalities : [raid1]=20
md126 : active raid1 sdb[0]
      31457280 blocks super external:/md127/0 [2/1] [_U]
     =20
md127 : inactive sda[1](S) sdb[0](S)
      6306 blocks super external:imsm
      =20

Thanks,

Mike.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
