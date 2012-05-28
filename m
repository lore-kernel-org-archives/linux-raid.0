From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: raid10 devices all marked as spares?!
Date: Mon, 28 May 2012 22:50:03 +0200
Message-ID: <4FC3E4FB.4010003@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I'm sorry if this is the wrong place to start, but I've been quite lost 
as to what is going wrong here.

I've been having some issues latly with my raid10 array. First some info.

I have three raid10 arrays on my gentoo box on 2 drives using GPT.
I was running 3.2.1 at the time but have 3.4.0 running at the moment.
mdadm - v3.2.5 - 18th May 2012


md0, a 2 far-copies, 1.2 metadata, raid10 array  consisting of /dev/sda4 
and sdb4.
md1, a 2 offset-copies, 1.2 metadata, raid10 array consisting of 
/dev/sda5 and sdb5
md2, a 2 offset-copies, 1.2 metadata, raid10 array consisting of 
/dev/sda6 and sdb6

sd*1 is bios_grub data, sd*2 is 256mb fat for playing with uefi and sd*3 
is 8gigs of unused space, may have some version of ubuntu on it and sd*7 
for swap.

For all of this, md0 has always worked normally. it is being assembled 
from initramfs where a static mdadm lives as such:
/bin/mdadm -A /dev/md0 -R -a md /dev/sda4 /dev/sdb4 || exit 1

md1 and md2 are being brought up during boot, md0 holds root, /usr etc 
wheras md1 are just for home and data.

The last few weeks md1 and md2 randomly fail to come up properly. md1 or 
md2 come up as inactive and one of the two drivers are marked as spares. 
(Why as spares? Why won't it try to run the array with a missing drive?) 
While this happens, it's completly abitrary whether sda or sdb is being 
used. so md1 can be sda5[2](S) and md2 can be sdb5[2](S).

When this happens, I mdadm --stop /dev/md1 and /dev/md2, followed 
immediatly by mdadm -A /dev/md1 (using mdadm.conf which doesn't even 
list the devices. ARRAY /dev/md1 metadata=1.2 UUID=nnn name=host:home). 
The arrays come up and work just fine.

What happend today however, is that md2 again does not come up, and 
sda6[3](S) shows in /proc/mdadm. However re-assembly of the array fails 
and only using mdadm -A /dev/md2 /dev/sda6 /dev/sdb6 shows:
mdadm: device 1 in /dev/md2 has wrong state in superblock, but /dev/sdb6 
seems ok
mdadm: /dev/md2 assembled from 0 drives and 2 spares - not enough to 
start the array.
/proc/mdadm shows as somewhat expected.
md2 : inactive sda6[3](S) sdb6[2](S)

Only using sdb6 however also fails. I guess because it does not want to 
use a spare.
mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
mdadm: Not enough devices to start the array.

Now the really disturbing part comes from mdadm --examine.
valexia oliver # mdadm --examine /dev/sda6
/dev/sda6:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : nnnn
            Name : host:opt  (local to host host)
   Creation Time : Sun Aug 28 17:46:27 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 456165376 (217.52 GiB 233.56 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : nnnn

     Update Time : Mon May 28 20:52:35 2012
        Checksum : ac17255 - correct
          Events : 1


    Device Role : spare
    Array State :  ('A' == active, '.' == missing)

sdb6 lists identical content only with the checksum's being correbt, 
albeit different and of coruse the Device UUID. Array UUID is of course 
identical as is creation time.

Also to note, is that grub2 does mention an 'error: Unsupported RAID 
level: -1000000.' which probably relates to the 'Raid Level: -unknown-'.

As to what may have caused this? I have absolutely no idea. I did a 
clean shutdown where the arrays get cleanly unmounted. Not 100% sure if 
the arrays get --stopped but I would be surprised if they did not.

So I guess is this a md driver bug? Is there anything I can do to 
recover my data, which i cannot image it not being?

Thanks in advance for reading this.

Oliver
