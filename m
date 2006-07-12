From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re: Problem with 3xRAID1 to RAID 0
Date: Wed, 12 Jul 2006 12:06:43 +0400
Message-ID: <273427381.20060712120643@2ka.mipt.ru>
References: <44B3562B.7040801@vladoportos.sk>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44B3562B.7040801@vladoportos.sk>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Strycek <vladoportos@vladoportos.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Vladimir,

Tuesday, July 11, 2006, 11:41:31 AM, you wrote:

VS> Hi,

VS> I created to 3 x /dev/md1 to /dev/md3  which consist of six identical
VS> 200GB hdd

VS> my mdadm --detail --scan looks like

VS> Proteus:/home/vladoportos# mdadm --detail --scan
VS> ARRAY /dev/md1 level=raid1 num-devices=2
VS> UUID=d1fadb29:cc004047:aabf2f31:3f044905
VS>    devices=/dev/sdb,/dev/sda
VS> ARRAY /dev/md2 level=raid1 num-devices=2
VS> UUID=38babb4d:92129d4a:94d659f1:3b238c53
VS>    devices=/dev/sdc,/dev/sdd
VS> ARRAY /dev/md3 level=raid1 num-devices=2
VS> UUID=a0406e29:c1f586be:6b3381cf:086be0c2
VS>    devices=/dev/sde,/dev/sdf
VS> ARRAY /dev/md0 level=raid1 num-devices=2
VS> UUID=c04441d4:e15d900e:57903584:9eb5fea6
VS>    devices=/dev/hdc1,/dev/hdd1


VS> and mdadm.conf

VS> DEVICE partitions
VS> ARRAY /dev/md4 level=raid0 num-devices=3
VS> UUID=1c8291ba:2d83cf54:2698ce30:e49b1e6c
VS>    devices=/dev/md1,/dev/md2,/dev/md3
VS> ARRAY /dev/md3 level=raid1 num-devices=2
VS> UUID=a0406e29:c1f586be:6b3381cf:086be0c2
VS>    devices=/dev/sde,/dev/sdf
VS> ARRAY /dev/md2 level=raid1 num-devices=2
VS> UUID=38babb4d:92129d4a:94d659f1:3b238c53
VS>    devices=/dev/sdc,/dev/sdd
VS> ARRAY /dev/md1 level=raid1 num-devices=2
VS> UUID=d1fadb29:cc004047:aabf2f31:3f044905
VS>    devices=/dev/sda,/dev/sdb
VS> ARRAY /dev/md0 level=raid1 num-devices=2
VS> UUID=c04441d4:e15d900e:57903584:9eb5fea6
VS>    devices=/dev/hdc1,/dev/hdd1



VS> as you can see i created than from md1-3 RAID0 - md4 its works fine...
VS> but i cant get it again after reboot i need to create it again...

VS> I dont get it why it wont creat at boot...  any body had similar problem ?
I haven't had a problem like this, but taking a wild guess - did you
try putting the definitions in mdadm.conf in a different order?

In particular, you define md4 before the system knows anything about
the devices md[1-3]...

You can speed up the checks (I think) by using something like this
instead of rebooting full-scale, except for the last check to see if
it all actually works :)
mdadm --stop /dev/md4
mdadm --stop /dev/md3
mdadm --stop /dev/md2
mdadm --stop /dev/md1

mdadm -As
or
mdadm -Asc /etc/mdadm.conf.test

Also you seem to make the md[1-3] devices from whole disks.
Had you made them from partitions you could
1) Set a partition type to 0xfd so that a proper kernel could make
   your raid1 sets at boot-time and then make md4 correctly even
   with the current config file
2) Move the submirrors to another disk (i.e. a new larger one)
   if you needed to rebuild, upgrade, recover, etc. by just making
   a new partition of the same size.
   Also keep in mind that "200Gb" (and any other) disks of different
   models and makers can vary in size by several tens of megabytes...
   Bit me once with certain 36Gb SCSI disks which were somewhat
   larger than any competition, so we had to hunt for the same model
   to rebuild our array.

A question to the general public: am I wrong? :)
Are there any actual bonuses to making RAIDs on whole raw disks?

-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

