From: Caspar Smit <c.smit@truebit.nl>
Subject: mdadm won't remove drive from array
Date: Mon, 24 Feb 2014 11:51:00 +0100
Message-ID: <CAKFseUP0_Y3ZuBKKrTD6WPCRoYraKk4+3sogxmbXQwikh2Wi=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I'm having trouble removing a failed drive from an array.

#cat /proc/mdstat

md5 : active raid6 sdn[14](S) sdm[13](S) sdad[12] sdl[11] sdba[10]
sde[0](F) sdd[9] sdc[8] sdk[7] sdj[6] sdi[5] sdh[3] sdg[2]
      15628103680 blocks super 1.2 level 6, 512k chunk, algorithm 2
[10/10] [UUUUUUUUUU]

The drive in question is sde

#mdadm --remove /dev/md5 /dev/sde
mdadm: cannot find /dev/sde: No such file or directory

The drive crashed so hard it is not visible to the kernel anymore.

# cat /proc/partitions |grep sde
<no output>

Normally in such case i do:

#mdadm --remove /dev/md5 detached
<no output>

The drive remains in the array.

Is there any other way to remove this detached drive from the array
without having to stop/start the array or is this a (known) bug?

# mdadm -V
mdadm - v3.1.4 - 31st August 2010

# uname -a
Linux supernas01 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.39-2~bpo60+1
x86_64 GNU/Linux

Kind regards,
Caspar Smit
