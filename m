From: NeilBrown <neilb@suse.de>
Subject: Re: Need help recovering RAID5 array
Date: Tue, 9 Aug 2011 09:12:14 +1000
Message-ID: <20110809091214.4a830696@notabene.brown>
References: <4E3C0BCA.9000407@uml.edu>
	<20110806112910.332d450a@notabene.brown>
	<D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Muskiewicz, Stephen C" <Stephen_Muskiewicz@uml.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 8 Aug 2011 17:41:34 +0000 "Muskiewicz, Stephen C"
<Stephen_Muskiewicz@uml.edu> wrote:

> I tried creating a symlink /dev/md/tsongas_archive to /dev/md/51 but still got the "no suitable drives" error when trying to assemble (using both /dev/md/51 or /dev/md/tsongas_archive)
> 
> > 
> > When you can access the server again, could you report:
> > 
> >   cat /proc/mdstat
> >   grep md /proc/partitions
> >   ls -l /dev/md*
> > 
> > and maybe
> >   mdadm -Ds
> >   mdadm -Es
> >   cat /etc/mdadm.conf
> > 
> > just for completeness.
> > 
> > 
> > It certainly looks like your data is all there but maybe not appearing
> > exactly where you expect it.
> > 
> 
> Here is all is:
> 
> [root@libthumper1 ~]# cat /proc/mdstat 
> Personalities : [raid1] [raid6] [raid5] [raid4] 
> md53 : active raid5 sdae1[0] sds1[8](S) sdai1[9](S) sdk1[10] sdam1[6] sdo1[5] sdau1[4] sdaq1[3] sdw1[2] sdaa1[1]
>       3418686208 blocks super 1.0 level 5, 128k chunk, algorithm 2 [8/8] [UUUUUUUU]
>       
> md52 : active raid5 sdad1[0] sdf1[11](S) sdz1[10](S) sdb1[12] sdn1[8] sdj1[7] sdal1[6] sdah1[5] sdat1[4] sdap1[3] sdv1[2] sdr1[1]
>       4395453696 blocks super 1.0 level 5, 128k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
>       
> md0 : active raid1 sdac2[0] sdy2[1]
>       480375552 blocks [2/2] [UU]
>       
> unused devices: <none>
> 
> [root@libthumper1 ~]# grep md /proc/partitions 
>    9     0  480375552 md0
>    9    52 4395453696 md52
>    9    53 3418686208 md53
> 
> 
> [root@libthumper1 ~]# ls -l /dev/md*
> brw-r----- 1 root disk 9, 0 Aug  4 15:25 /dev/md0
> lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md51 -> md/51
> 
> lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md52 -> md/52
> 
> lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md53 -> md/53
> 
> 
> /dev/md:
> total 0
> brw-r----- 1 root disk 9, 51 Aug  4 15:25 51
> brw-r----- 1 root disk 9, 52 Aug  4 15:25 52
> brw-r----- 1 root disk 9, 53 Aug  4 15:25 53
> 
> [root@libthumper1 ~]# mdadm -Ds
> ARRAY /dev/md0 level=raid1 num-devices=2 metadata=0.90 UUID=e30f5b25:6dc28a02:1b03ab94:da5913ed
> ARRAY /dev/md52 level=raid5 num-devices=10 metadata=1.00 spares=2 name=vmware_storage UUID=c436b591:01a4be5f:2736d7dd:3b97d872
> ARRAY /dev/md53 level=raid5 num-devices=8 metadata=1.00 spares=2 name=backup_mirror UUID=9bb89570:675f47be:2fe2f481:ebc33388
> 
> [root@libthumper1 ~]# mdadm -Es
> ARRAY /dev/md2 level=raid1 num-devices=6 UUID=d08b45a4:169e4351:02cff74a:c70fcb00
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=e30f5b25:6dc28a02:1b03ab94:da5913ed
> ARRAY /dev/md/tsongas_archive level=raid5 metadata=1.0 num-devices=8 UUID=41aa414e:cfe1a5ae:3768e4ef:0084904e name=tsongas_archive
> ARRAY /dev/md/vmware_storage level=raid5 metadata=1.0 num-devices=10 UUID=c436b591:01a4be5f:2736d7dd:3b97d872 name=vmware_storage
> ARRAY /dev/md/backup_mirror level=raid5 metadata=1.0 num-devices=8 UUID=9bb89570:675f47be:2fe2f481:ebc33388 name=backup_mirror
> 
> [root@libthumper1 ~]# cat /etc/mdadm.conf
> 
> # mdadm.conf written out by anaconda
> DEVICE partitions
> MAILADDR sysadmins
> MAILFROM root@libthumper1.uml.edu
> ARRAY /dev/md0 level=raid1 num-devices=2 uuid=e30f5b25:6dc28a02:1b03ab94:da5913ed
> ARRAY /dev/md/51 level=raid5 num-devices=8 spares=2 name=tsongas_archive uuid=41aa414e:cfe1a5ae:3768e4ef:0084904e
> ARRAY /dev/md/52 level=raid5 num-devices=10 spares=2 name=vmware_storage uuid=c436b591:01a4be5f:2736d7dd:3b97d872
> ARRAY /dev/md/53 level=raid5 num-devices=8 spares=2 name=backup_mirror uuid=9bb89570:675f47be:2fe2f481:ebc33388
> 
> It looks like the md51 device isn't appearing in /proc/partitions, not sure why that is?
> 
> I also just noticed the /dev/md2 that appears in the mdadm -Es output, not sure what that is but I don't recognize it as anything that was previously on that box.  (There is no /dev/md2 device file).  Not sure if that is related at all or just a red herring...
> 
> For good measure, here's some actual mdadm -E output for the specific drives (I won't include all as they all seem to be about the same):
> 
> [root@libthumper1 ~]# mdadm -E /dev/sd[qui]1
> /dev/sdi1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
>            Name : tsongas_archive
>   Creation Time : Thu Feb 24 11:43:37 2011
>      Raid Level : raid5
>    Raid Devices : 8
> 
>  Avail Dev Size : 976767728 (465.76 GiB 500.11 GB)
>      Array Size : 6837372416 (3260.31 GiB 3500.73 GB)
>   Used Dev Size : 976767488 (465.76 GiB 500.10 GB)
>    Super Offset : 976767984 sectors
>           State : clean
>     Device UUID : 750e6410:661d4838:0a5f7581:7c110cf1
> 
>     Update Time : Thu Aug  4 06:41:23 2011
>        Checksum : 20bb0567 - correct
>          Events : 18446744073709551615

...

> 
> Is that huge number for the event count perhaps a problem? 

Could be.  That number is 0xffff,ffff,ffff,ffff.  i.e.2^64-1.
It cannot get any bigger than that.

> > 
> 
> OK so I tried with the --force and here's what I got (BTW the device names are different from my original email since I didn't have access to the server before, but I used the real device names exactly as when I originally created the array, sorry for any confusion)
> 
> mdadm -A /dev/md/51 --force /dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 /dev/sdm1 /dev/sda1 /dev/sdak1 /dev/sde1
> 
> mdadm: forcing event count in /dev/sdq1(0) from -1 upto -1
> mdadm: forcing event count in /dev/sdu1(1) from -1 upto -1
> mdadm: forcing event count in /dev/sdao1(2) from -1 upto -1
> mdadm: forcing event count in /dev/sdas1(3) from -1 upto -1
> mdadm: forcing event count in /dev/sdag1(4) from -1 upto -1
> mdadm: forcing event count in /dev/sdi1(5) from -1 upto -1
> mdadm: forcing event count in /dev/sdm1(6) from -1 upto -1
> mdadm: forcing event count in /dev/sda1(7) from -1 upto -1
> mdadm: failed to RUN_ARRAY /dev/md/51: Input/output error

and sometimes "2^64-1" looks like "-1".

We just need to replace that "-1" with a more useful number.

It looks the the "--force" might have made a little bit of a mess but we
should be able to recover it.

Could you:
  apply the following patch and build a new 'mdadm'.
  mdadm -S /dev/md/51
  mdadm -A /dev/md/51 --update=summaries
-vv /dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 /dev/sdm1 /dev/sda1 /dev/sdak1 /dev/sde1

and if that doesn't work, repeat the same two commands but add "--force" to
the second.  Make sure you keep the "-vv" in both cases.

then report the results.

I wonder how the event count got that high.  There aren't enough seconds
since the birth of the universe of it to have happened naturally...


Thanks,
NeilBrown

diff --git a/super1.c b/super1.c
index 35e92a3..4a3341a 100644
--- a/super1.c
+++ b/super1.c
@@ -803,6 +803,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		       __le64_to_cpu(sb->data_size));
 	} else if (strcmp(update, "_reshape_progress")==0)
 		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
+	else if (strcmp(update, "summaries") == 0)
+		sb->events = __cpu_to_le64(4);
 	else
 		rv = -1;
 
