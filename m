From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Raid1 and Sun Ultra5
Date: Wed, 13 Nov 2002 11:25:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.0.20021113111822.00a4aec0@bsing.ing.unibs.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have just installed Debian Woody on a Ultra5 box:
I spanned a Raid1 volume across two ide disks:

hda6, hdc6

and I'm sure /etc/raidtab is correct (I use software raid from the 
beginning...)
let me show you:

raiddev                 /dev/md0
raid-level              1
persistent-superblock   1
nr-raid-disks           2
nr-spare-disks          0
chunk-size              4
device                  /dev/hda6
raid-disk               0
device                  /dev/hdc6
raid-disk               1

When I do mkraid I can see from /proc/mdstat that
everything is going well. During the construction of the volume
I can create a ext2 or ext3 filesystem on it, I can mount it
and read, write files on it.

AND...

when the construction of the volume finishes I can't do
ANYTHING on the volume. e.g. if I try to mount it I get:

data_access_exception: SFSR[0000000000801009] SFAR[fffff80338e39efc], going.
               \|/ ____ \|/
               "@'/ .. \`@"
               /_| \__/ |_\
                  \__U_/
mount(566): Dax

I tested this with the 2.4.18 kernel which comes with the
Debian distribution and with the 2.4.19 kernel which I have
compiled: nothing changes.
Surprise: the same thing does not happen with a raid0 volume.

Suggestion?

Thanks in advance
Francesco

