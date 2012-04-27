From: likewhoa <likewhoa@weboperative.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Fri, 27 Apr 2012 19:29:37 -0400
Message-ID: <4F9B2BE1.5080207@weboperative.com>
References: <4F9AFBC6.7070803@weboperative.com> <4F9B14FA.1090001@weboperative.com> <20120428080522.637bc564@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120428080522.637bc564@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/27/2012 06:05 PM, NeilBrown wrote:
> On Fri, 27 Apr 2012 17:51:54 -0400 likewhoa <likewhoa@weboperative.com> wrote:
>
>
>> adding more verbose info gives me:
>>
>>> -> mdadm -A --verbose /dev/md1
>> mdadm: looking for devices for /dev/md1
>> mdadm: /dev/dm-8 is not one of
>> /dev/sdg3,/dev/sdf3,/dev/sde3,/dev/sdd3,/dev/sdb3,/dev/sda3,/dev/sdc3
> You seem to have an explicit list of devices in /etc/mdadm.conf
> This is not a good idea for 'sd' devices as they can change their names,
> which can mean they aren't on the list any more.  You should remove that
> once you get this all sorted out.
>
> NeilBrown
>
>
@Neil sorry but I didn't get to reply to all on my last 2 emails, so
here is goes again so it's archived.

/dev/sdh3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 828ed03d:0c28afda:4a636e88:7b29ec9f
           Name : Darkside:1  (local to host Darkside)
  Creation Time : Sun Aug 15 21:12:34 2010
     Raid Level : raid10
   Raid Devices : 8

 Avail Dev Size : 902993648 (430.58 GiB 462.33 GB)
     Array Size : 3611971584 (1722.32 GiB 1849.33 GB)
  Used Dev Size : 902992896 (430.58 GiB 462.33 GB)
   Super Offset : 902993904 sectors
          State : clean
    Device UUID : 00565578:e2eaaba3:f1eae17c:f474ee8d

    Update Time : Wed Apr 25 17:22:58 2012
       Checksum : 1e7c3692 - correct
         Events : 82942

         Layout : far=2
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : AAAAAAAA ('A' == active, '.' == missing)
 

The only drive that didn't get affected is far=3. Any suggestions? I
have the drives on separate controllers and when I created the array I
set up the order as /dev/sda3 /dev/sde3 /dev/sdb3 /dev/sdf3 and so on.
so I would assume the same order would be used, also note that I ran
luksFormat on /dev/md1 then ran pvcreate /dev/md1 and so on. Will I have
issues with luksOpen after recreating the array? I removed the /dev/sdh1
drive so now the output is like:

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4644f013

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sda2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sda3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e460f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdb2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdb3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x7d10530f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdc2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdc3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdd: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x81a213ab

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdd2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdd3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sde: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4644f00e

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sde2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sde3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdf: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4644f00c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdf2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdf3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdg: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x327d8d82

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdg2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdg3        73779200   976773119   451496960   fd  Linux raid
autodetect

Disk /dev/sdh: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e460f

   Device Boot      Start         End      Blocks   Id  System
/dev/sdh1            2048     2099199     1048576   82  Linux swap / Solaris
/dev/sdh2         2099200    73779199    35840000   fd  Linux raid
autodetect
/dev/sdh3        73779200   976773119   451496960   fd  Linux raid
autodetect

and

cat /proc/mdstat
Personalities : [raid10]
md127 : inactive sdb3[8](S) sdf3[13](S) sda3[11](S) sdc3[9](S)
sdd3[12](S) sdg3[10](S) sde3[15](S)
      3160477768 blocks super 1.0
      
md0 : active raid10 sdd2[12] sdh2[0] sdb2[8] sdf2[13] sdg2[10] sda2[11]
sde2[14] sdc2[9]
      143358976 blocks super 1.0 256K chunks 2 near-copies [8/8] [UUUUUUUU]
     
unused devices: <none>

and the output from you for loop.

/dev/sda3 and /dev/sdc3 seem to match
/dev/sda3 and /dev/sde3 seem to match
/dev/sda3 and /dev/sdg3 seem to match
/dev/sdc3 and /dev/sda3 seem to match
/dev/sdc3 and /dev/sde3 seem to match
/dev/sdc3 and /dev/sdg3 seem to match
/dev/sde3 and /dev/sda3 seem to match
/dev/sde3 and /dev/sdc3 seem to match
/dev/sde3 and /dev/sdg3 seem to match
/dev/sdg3 and /dev/sda3 seem to match
/dev/sdg3 and /dev/sdc3 seem to match
/dev/sdg3 and /dev/sde3 seem to match

Thanks in advanced Neil.
likewhoa


