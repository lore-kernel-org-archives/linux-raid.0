From: Yorik <yoriks13@westnet.com.au>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Mon, 31 Mar 2014 15:24:07 +0800
Message-ID: <CAFth78xfP7rEVJxWS=aL0zUPGSyDnmrPWcgE=XxjYSuWU4_zvQ@mail.gmail.com>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
	<CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
	<20140331172953.3f37f6c2@notabene.brown>
	<CAFth78wtf5X0ycUuKCTV3QSvs4Uv8mvvZYH2Vqhwc2WwOqkHfg@mail.gmail.com>
	<20140331181227.69c4e583@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140331181227.69c4e583@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

Thanks for your quick reply. :) Output as follows. and yes I agree.
sdf is strange, also some devices think the Array has different number
of devices Active.. It all got quite muddled up at the time of
failure.

[root@desktop mdadm]# ./mdadm --examine /dev/sd[abc]1 /dev/sd[defgi]
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:38:19 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 90e00065:90a8aa11:a636fb20:7b381843

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:38:19 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e84e430c - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:38:19 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 364b1f3d:060ba7b0:e1023e93:4dd320b8

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:38:19 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 46b47738 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:38:19 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : c90f3c3d:c0656476:2219a286:1f03efba

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:38:19 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2c0dc99 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:38:19 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=2992 sectors
          State : clean
    Device UUID : 8554f422:ec64f7bc:5c34f9b6:208c4c47

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:38:19 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ebc0d06c - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:38:19 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=2992 sectors
          State : clean
    Device UUID : 16f97e63:6c3ec636:2612a1ec:abce713a

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:38:19 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : cee76ed4 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAA.A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 26124817:0056ac1b:d1906468:a8784872
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:33:56 2014
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=2992 sectors
          State : clean
    Device UUID : 17feeac8:451539a0:c0ecdef8:1319398f

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:33:56 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c1d231a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a5cb0ced:fee37e80:bb291f1a:c5b2f600
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:28:54 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=2992 sectors
          State : clean
    Device UUID : 052e90fb:b4ed4385:d7cf3dec:ad9e7004

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:28:54 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 76aac59 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a5cb0ced:fee37e80:bb291f1a:c5b2f600
           Name : desktop.yorik:0  (local to host desktop.yorik)
  Creation Time : Tue Feb  4 00:28:54 2014
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 17580804096 (16766.36 GiB 18002.74 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=2992 sectors
          State : clean
    Device UUID : 96d39460:5658d235:111d5f75:33e188d3

Internal Bitmap : 8 sectors from superblock
    Update Time : Tue Feb  4 00:28:54 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 75374c49 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

Regards
Derek

On 31 March 2014 15:12, NeilBrown <neilb@suse.de> wrote:
> On Mon, 31 Mar 2014 14:54:31 +0800 Yorik <yoriks13@westnet.com.au> wrote:
>
>> Hi Neil
>>
>> Thanks very much for the help and advice.. Output as follows.
>>
>> [root@desktop mdadm]# ./mdadm --assemble --force --verbose /dev/md0
>> /dev/sd[abc]1 /dev/sd[defgi]
>> mdadm: looking for devices for /dev/md0
>> mdadm: superblock on /dev/sdf doesn't match others - assembly aborted
>>
>>
>> Maybe there has been some differences in Data Offset and superblock
>> sizes with different versions of mdadm. I am not really sure what to
>> do now, I just got back from a long project overseas and was about to
>> start looking deeper into my options.
>>
>> Appreciate any further help or advice that you have.
>
>
> Could you post the full output of
>   mdadm --examine /dev/[abc]1 /dev/sd[defgi]
>
> Some is clearly different at least with sdf.
>
> NeilBrown
>
>>
>> Regards
>> Derek
>>
>> On 31 March 2014 14:29, NeilBrown <neilb@suse.de> wrote:
>> > On Sat, 1 Feb 2014 15:56:14 +0800 Yorik <yoriks13@westnet.com.au> wrote:
>> >
>> >> Thank you for your help. Sorry for my omission, I thought I had put
>> >> that in. It was one of the first things that I tried and have numerous
>> >> times since.
>> >>
>> >> #mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
>> >> mdadm: /dev/md0 assembled from 5 drives - not enough to start the array.
>> >>
>> >> Then if I try the command again, I get the following
>> >>
>> >> # mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
>> >> mdadm: /dev/sda1 is busy - skipping
>> >> mdadm: /dev/sdb1 is busy - skipping
>> >> mdadm: /dev/sdc1 is busy - skipping
>> >> mdadm: /dev/sdd is busy - skipping
>> >> mdadm: /dev/sde is busy - skipping
>> >> mdadm: /dev/sdf is busy - skipping
>> >> mdadm: /dev/sdg is busy - skipping
>> >> mdadm: /dev/sdi is busy - skipping
>> >>
>> >> And my /proc/mdstat looks like this, with all drives marked as spare.
>> >>
>> >> # cat /proc/mdstat
>> >> Personalities :
>> >> md0 : inactive sda1[0](S) sdf[7](S) sdg[8](S) sde[5](S) sdi[6](S)
>> >> sdd[4](S) sdc1[2](S) sdb1[1](S)
>> >>       23442114872 blocks super 1.1
>> >>
>> >> unused devices: <none>
>> >
>> > If this is still a problem then please:
>> > 1/ get the latest mdadm:
>> >      cd /tmp
>> >      git clone git://neil.brown.name/mdadm
>> >      cd mdadm
>> >      make
>> > 2/ stop the array
>> >      ./mdadm --stop /dev/md0
>> > 3/ force-assemble the array with --verbose:
>> >
>> >      ./mdadm --assemble --force --verbose /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
>> >
>> > and report all the output of the last command.
>> >
>> > NeilBrown
>> >
>
