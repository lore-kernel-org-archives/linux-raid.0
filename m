From: Jon Lewis <jlewis@lewis.org>
Subject: Re: md: could not bd_claim hde1
Date: Sun, 11 Oct 2009 00:58:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0910110051270.22812@soloth.lewis.org>
References: <Pine.LNX.4.61.0910102326250.22812@soloth.lewis.org>
 <738ae0e0ab81ff72cc23b359d0011d1c.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <738ae0e0ab81ff72cc23b359d0011d1c.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 11 Oct 2009, NeilBrown wrote:

> Either hde1 or hde is definitely in use by something else.
> Try:
> cat /proc/mounts

# cat /proc/mounts
rootfs / rootfs rw 0 0
/proc /proc proc rw,nodiratime 0 0
none /dev tmpfs rw 0 0
/dev/root / ext3 rw 0 0
none /dev tmpfs rw 0 0
/proc /proc proc rw,nodiratime 0 0
/proc/bus/usb /proc/bus/usb usbfs rw 0 0
/sys /sys sysfs rw 0 0
none /dev/pts devpts rw 0 0
none /dev/shm tmpfs rw 0 0
/dev/md1 /var ext3 rw 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw 0 0
[there's a remote nfs mount here that I've removed]

> cat /proc/swaps

# cat /proc/swaps
Filename                                Type            Size    Used    Priority
/dev/hdg2                               partition       1052248 160     -1

> ls -l /sys/block/hde1/holders
> ls -l /sys/block/hde/holders

# ls -ld /sys/block/hd*
drwxr-xr-x  3 root root 0 Oct 11 00:53 /sys/block/hda
drwxr-xr-x  6 root root 0 Oct 11 00:53 /sys/block/hde
drwxr-xr-x  6 root root 0 Oct 11 00:53 /sys/block/hdg

# ls -l /sys/block/hde
total 0
-r--r--r--  1 root root 4096 Oct 11 00:53 dev
lrwxrwxrwx  1 root root    0 Oct 11 00:53 device -> ../../devices/pci0000:00/0000:00:02.0/0000:02:1f.0/0000:03:03.0/0000:04:0c.0/ide2/2.0
drwxr-xr-x  2 root root    0 Oct  9 23:52 hde1
drwxr-xr-x  2 root root    0 Oct  9 23:52 hde2
drwxr-xr-x  2 root root    0 Oct  9 23:52 hde3
drwxr-xr-x  3 root root    0 Oct  9 23:52 queue
-r--r--r--  1 root root 4096 Oct 11 00:53 range
-r--r--r--  1 root root 4096 Oct 11 00:53 removable
-r--r--r--  1 root root 4096 Oct 11 00:53 size
-r--r--r--  1 root root 4096 Oct 11 00:53 stat

# ls -l /sys/block/hde/hde1/
total 0
-r--r--r--  1 root root 4096 Oct 11 00:54 dev
-r--r--r--  1 root root 4096 Oct 11 00:54 size
-r--r--r--  1 root root 4096 Oct 11 00:54 start
-r--r--r--  1 root root 4096 Oct 11 00:54 stat
# ls -l /sys/block/hde/hde3/
total 0
-r--r--r--  1 root root 4096 Oct 11 00:54 dev
-r--r--r--  1 root root 4096 Oct 11 00:54 size
-r--r--r--  1 root root 4096 Oct 11 00:54 start
-r--r--r--  1 root root 4096 Oct 11 00:54 stat

> cat /proc/mdstat

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 hdg3[1]
       38547840 blocks [2/1] [_U]

md0 : active raid1 hdg1[1]
       38547840 blocks [2/1] [_U]

unused devices: <none>

> lsof /dev/hde /dev/hde1

# lsof /dev/hde /dev/hde1
#

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
