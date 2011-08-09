From: Stephen Muskiewicz <stephen_muskiewicz@uml.edu>
Subject: Re: Need help recovering RAID5 array
Date: Mon, 8 Aug 2011 22:29:10 -0400
Message-ID: <4E409B76.5030000@uml.edu>
References: <4E3C0BCA.9000407@uml.edu>	<20110806112910.332d450a@notabene.brown>	<D32562736F94C445958A7CC900A95568265503@PORSCHE.fs.uml.edu> <20110809091214.4a830696@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110809091214.4a830696@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/8/2011 7:12 PM, NeilBrown wrote:
>> [root@libthumper1 ~]# cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md53 : active raid5 sdae1[0] sds1[8](S) sdai1[9](S) sdk1[10] sdam1[6] sdo1[5] sdau1[4] sdaq1[3] sdw1[2] sdaa1[1]
>>        3418686208 blocks super 1.0 level 5, 128k chunk, algorithm 2 [8/8] [UUUUUUUU]
>>
>> md52 : active raid5 sdad1[0] sdf1[11](S) sdz1[10](S) sdb1[12] sdn1[8] sdj1[7] sdal1[6] sdah1[5] sdat1[4] sdap1[3] sdv1[2] sdr1[1]
>>        4395453696 blocks super 1.0 level 5, 128k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
>>
>> md0 : active raid1 sdac2[0] sdy2[1]
>>        480375552 blocks [2/2] [UU]
>>
>> unused devices:<none>
>>
>> [root@libthumper1 ~]# grep md /proc/partitions
>>     9     0  480375552 md0
>>     9    52 4395453696 md52
>>     9    53 3418686208 md53
>>
>>
>> [root@libthumper1 ~]# ls -l /dev/md*
>> brw-r----- 1 root disk 9, 0 Aug  4 15:25 /dev/md0
>> lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md51 ->  md/51
>>
>> lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md52 ->  md/52
>>
>> lrwxrwxrwx 1 root root    5 Aug  4 15:25 /dev/md53 ->  md/53
>>
>>
>> /dev/md:
>> total 0
>> brw-r----- 1 root disk 9, 51 Aug  4 15:25 51
>> brw-r----- 1 root disk 9, 52 Aug  4 15:25 52
>> brw-r----- 1 root disk 9, 53 Aug  4 15:25 53
>>
>> [root@libthumper1 ~]# mdadm -Ds
>> ARRAY /dev/md0 level=raid1 num-devices=2 metadata=0.90 UUID=e30f5b25:6dc28a02:1b03ab94:da5913ed
>> ARRAY /dev/md52 level=raid5 num-devices=10 metadata=1.00 spares=2 name=vmware_storage UUID=c436b591:01a4be5f:2736d7dd:3b97d872
>> ARRAY /dev/md53 level=raid5 num-devices=8 metadata=1.00 spares=2 name=backup_mirror UUID=9bb89570:675f47be:2fe2f481:ebc33388
>>
>> [root@libthumper1 ~]# mdadm -Es
>> ARRAY /dev/md2 level=raid1 num-devices=6 UUID=d08b45a4:169e4351:02cff74a:c70fcb00
>> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=e30f5b25:6dc28a02:1b03ab94:da5913ed
>> ARRAY /dev/md/tsongas_archive level=raid5 metadata=1.0 num-devices=8 UUID=41aa414e:cfe1a5ae:3768e4ef:0084904e name=tsongas_archive
>> ARRAY /dev/md/vmware_storage level=raid5 metadata=1.0 num-devices=10 UUID=c436b591:01a4be5f:2736d7dd:3b97d872 name=vmware_storage
>> ARRAY /dev/md/backup_mirror level=raid5 metadata=1.0 num-devices=8 UUID=9bb89570:675f47be:2fe2f481:ebc33388 name=backup_mirror
>>
>> [root@libthumper1 ~]# cat /etc/mdadm.conf
>>
>> # mdadm.conf written out by anaconda
>> DEVICE partitions
>> MAILADDR sysadmins
>> MAILFROM root@libthumper1.uml.edu
>> ARRAY /dev/md0 level=raid1 num-devices=2 uuid=e30f5b25:6dc28a02:1b03ab94:da5913ed
>> ARRAY /dev/md/51 level=raid5 num-devices=8 spares=2 name=tsongas_archive uuid=41aa414e:cfe1a5ae:3768e4ef:0084904e
>> ARRAY /dev/md/52 level=raid5 num-devices=10 spares=2 name=vmware_storage uuid=c436b591:01a4be5f:2736d7dd:3b97d872
>> ARRAY /dev/md/53 level=raid5 num-devices=8 spares=2 name=backup_mirror uuid=9bb89570:675f47be:2fe2f481:ebc33388
>>
>> It looks like the md51 device isn't appearing in /proc/partitions, not sure why that is?
>>
>> I also just noticed the /dev/md2 that appears in the mdadm -Es output, not sure what that is but I don't recognize it as anything that was previously on that box.  (There is no /dev/md2 device file).  Not sure if that is related at all or just a red herring...
>>
>> For good measure, here's some actual mdadm -E output for the specific drives (I won't include all as they all seem to be about the same):
>>
>> [root@libthumper1 ~]# mdadm -E /dev/sd[qui]1
>> /dev/sdi1:
>>            Magic : a92b4efc
>>          Version : 1.0
>>      Feature Map : 0x0
>>       Array UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
>>             Name : tsongas_archive
>>    Creation Time : Thu Feb 24 11:43:37 2011
>>       Raid Level : raid5
>>     Raid Devices : 8
>>
>>   Avail Dev Size : 976767728 (465.76 GiB 500.11 GB)
>>       Array Size : 6837372416 (3260.31 GiB 3500.73 GB)
>>    Used Dev Size : 976767488 (465.76 GiB 500.10 GB)
>>     Super Offset : 976767984 sectors
>>            State : clean
>>      Device UUID : 750e6410:661d4838:0a5f7581:7c110cf1
>>
>>      Update Time : Thu Aug  4 06:41:23 2011
>>         Checksum : 20bb0567 - correct
>>           Events : 18446744073709551615
> ...
>
>> Is that huge number for the event count perhaps a problem?
> Could be.  That number is 0xffff,ffff,ffff,ffff.  i.e.2^64-1.
> It cannot get any bigger than that.
>
>> OK so I tried with the --force and here's what I got (BTW the device names are different from my original email since I didn't have access to the server before, but I used the real device names exactly as when I originally created the array, sorry for any confusion)
>>
>> mdadm -A /dev/md/51 --force /dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 /dev/sdm1 /dev/sda1 /dev/sdak1 /dev/sde1
>>
>> mdadm: forcing event count in /dev/sdq1(0) from -1 upto -1
>> mdadm: forcing event count in /dev/sdu1(1) from -1 upto -1
>> mdadm: forcing event count in /dev/sdao1(2) from -1 upto -1
>> mdadm: forcing event count in /dev/sdas1(3) from -1 upto -1
>> mdadm: forcing event count in /dev/sdag1(4) from -1 upto -1
>> mdadm: forcing event count in /dev/sdi1(5) from -1 upto -1
>> mdadm: forcing event count in /dev/sdm1(6) from -1 upto -1
>> mdadm: forcing event count in /dev/sda1(7) from -1 upto -1
>> mdadm: failed to RUN_ARRAY /dev/md/51: Input/output error
> and sometimes "2^64-1" looks like "-1".
>
> We just need to replace that "-1" with a more useful number.
>
> It looks the the "--force" might have made a little bit of a mess but we
> should be able to recover it.
>
> Could you:
>    apply the following patch and build a new 'mdadm'.
>    mdadm -S /dev/md/51
>    mdadm -A /dev/md/51 --update=summaries
> -vv /dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 /dev/sdm1 /dev/sda1 /dev/sdak1 /dev/sde1
>
> and if that doesn't work, repeat the same two commands but add "--force" to
> the second.  Make sure you keep the "-vv" in both cases.
>
> then report the results.
>

Well it looks like the first try didn't work, but adding the --force 
seems to have done the trick!  Here's the results:

[root@libthumper1 ~]# /root/mdadm -V
mdadm - v3.2.2 - 17th June 2011

[root@libthumper1 ~]# /root/mdadm -S /dev/md/51
mdadm: stopped /dev/md/51

[root@libthumper1 ~]# /root/mdadm -A /dev/md/51 --update=summaries -vv \
 > /dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 
/dev/sdm1 \
 > /dev/sda1 /dev/sdak1 /dev/sde1
mdadm: looking for devices for /dev/md/51
mdadm: /dev/sdq1 is identified as a member of /dev/md/51, slot 0.
mdadm: /dev/sdu1 is identified as a member of /dev/md/51, slot 1.
mdadm: /dev/sdao1 is identified as a member of /dev/md/51, slot 2.
mdadm: /dev/sdas1 is identified as a member of /dev/md/51, slot 3.
mdadm: /dev/sdag1 is identified as a member of /dev/md/51, slot 4.
mdadm: /dev/sdi1 is identified as a member of /dev/md/51, slot 5.
mdadm: /dev/sdm1 is identified as a member of /dev/md/51, slot 6.
mdadm: /dev/sda1 is identified as a member of /dev/md/51, slot 7.
mdadm: /dev/sdak1 is identified as a member of /dev/md/51, slot -1.
mdadm: /dev/sde1 is identified as a member of /dev/md/51, slot -1.
mdadm: added /dev/sdq1 to /dev/md/51 as 0
mdadm: added /dev/sdu1 to /dev/md/51 as 1
mdadm: added /dev/sdao1 to /dev/md/51 as 2
mdadm: added /dev/sdas1 to /dev/md/51 as 3
mdadm: added /dev/sdag1 to /dev/md/51 as 4
mdadm: added /dev/sdi1 to /dev/md/51 as 5
mdadm: added /dev/sdm1 to /dev/md/51 as 6
mdadm: added /dev/sda1 to /dev/md/51 as 7
mdadm: added /dev/sde1 to /dev/md/51 as -1
mdadm: added /dev/sdak1 to /dev/md/51 as -1
mdadm: /dev/md/51 assembled from 0 drives and 2 spares - not enough to 
start the array.

[root@libthumper1 ~]# /root/mdadm --detail /dev/md/51
mdadm: md device /dev/md/51 does not appear to be active.

[root@libthumper1 ~]# /root/mdadm -S /dev/md/51
mdadm: stopped /dev/md/51

[root@libthumper1 ~]# /root/mdadm -A /dev/md/51 --force 
--update=summaries -vv
/dev/sdq1 /dev/sdu1 /dev/sdao1 /dev/sdas1 /dev/sdag1 /dev/sdi1 /dev/sdm1
/dev/sda1 /dev/sdak1 /dev/sde1
mdadm: looking for devices for /dev/md/51
mdadm: /dev/sdq1 is identified as a member of /dev/md/51, slot 0.
mdadm: /dev/sdu1 is identified as a member of /dev/md/51, slot 1.
mdadm: /dev/sdao1 is identified as a member of /dev/md/51, slot 2.
mdadm: /dev/sdas1 is identified as a member of /dev/md/51, slot 3.
mdadm: /dev/sdag1 is identified as a member of /dev/md/51, slot 4.
mdadm: /dev/sdi1 is identified as a member of /dev/md/51, slot 5.
mdadm: /dev/sdm1 is identified as a member of /dev/md/51, slot 6.
mdadm: /dev/sda1 is identified as a member of /dev/md/51, slot 7.
mdadm: /dev/sdak1 is identified as a member of /dev/md/51, slot -1.
mdadm: /dev/sde1 is identified as a member of /dev/md/51, slot -1.
mdadm: added /dev/sdu1 to /dev/md/51 as 1
mdadm: added /dev/sdao1 to /dev/md/51 as 2
mdadm: added /dev/sdas1 to /dev/md/51 as 3
mdadm: added /dev/sdag1 to /dev/md/51 as 4
mdadm: added /dev/sdi1 to /dev/md/51 as 5
mdadm: added /dev/sdm1 to /dev/md/51 as 6
mdadm: added /dev/sda1 to /dev/md/51 as 7
mdadm: added /dev/sdak1 to /dev/md/51 as -1
mdadm: added /dev/sde1 to /dev/md/51 as -1
mdadm: added /dev/sdq1 to /dev/md/51 as 0
mdadm: /dev/md/51 has been started with 8 drives and 2 spares.

[root@libthumper1 ~]# /root/mdadm --detail /dev/md/51
/dev/md/51:
         Version : 1.0
   Creation Time : Thu Feb 24 11:43:37 2011
      Raid Level : raid5
      Array Size : 3418686208 (3260.31 GiB 3500.73 GB)
   Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
    Raid Devices : 8
   Total Devices : 10
     Persistence : Superblock is persistent

     Update Time : Thu Aug  4 06:41:23 2011
           State : clean
  Active Devices : 8
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 128K

            Name : tsongas_archive
            UUID : 41aa414e:cfe1a5ae:3768e4ef:0084904e
          Events : 4

     Number   Major   Minor   RaidDevice State
        0      65        1        0      active sync   /dev/sdq1
        1      65       65        1      active sync   /dev/sdu1
        2      66      129        2      active sync   /dev/sdao1
        3      66      193        3      active sync   /dev/sdas1
        4      66        1        4      active sync   /dev/sdag1
        5       8      129        5      active sync   /dev/sdi1
        6       8      193        6      active sync   /dev/sdm1
        7       8        1        7      active sync   /dev/sda1

        8      66       65        -      spare   /dev/sdak1
        9       8       65        -      spare   /dev/sde1

So it looks like I'm in business again!  Many thanks!

This does lead to a question: Do you recommend (and is it safe on CentOS 
5.5?) for me to use the updated (3.2.2 with your patch) version of mdadm 
going forward in place of the CentOS version (2.6.9)?

> I wonder how the event count got that high.  There aren't enough seconds
> since the birth of the universe of it to have happened naturally...
>
Any chance it might be related to these kernel messages? I just noticed 
(guess I should be paying more attention to my logs) that there are tons 
of these messages repeated in my /var/log/messages file.  However as far 
as the RAID arrays themselves, we haven't seen any problems while they 
are running so I'm not sure what's causing these or whether they are 
insignificant.  Again, speculation on my part but given the huge event 
count from mdadm and the number of these messages it might seem that 
they are somehow related....

Jul 31 04:02:13 libthumper1 kernel: program diskmond is using a 
deprecated SCSI
ioctl, please convert it to SG_IO
Jul 31 04:02:26 libthumper1 last message repeated 47 times
Jul 31 04:12:11 libthumper1 kernel: md: bug in file drivers/md/md.c, 
line 1659
Jul 31 04:12:11 libthumper1 kernel:
Jul 31 04:12:11 libthumper1 kernel: md: **********************************
Jul 31 04:12:11 libthumper1 kernel: md: * <COMPLETE RAID STATE PRINTOUT> *
Jul 31 04:12:11 libthumper1 kernel: md: **********************************
Jul 31 04:12:11 libthumper1 kernel: md53: 
<sdk1><sdai1><sds1><sdam1><sdo1><sdau1><sdaq1><sdw1><sdaa1><sdae1>
Jul 31 04:12:11 libthumper1 kernel: md: rdev sdk1, SZ:488383744 F:0 S:1 
DN:10
Jul 31 04:12:11 libthumper1 kernel: md: rdev superblock:
Jul 31 04:12:11 libthumper1 kernel: md:  SB: (V:1.0.0) 
ID:<be475f67.00000000.00000000.00000000> CT:81f4e22f
Jul 31 04:12:11 libthumper1 kernel: md:     L-2009873429 S1801675106 
ND:1834971253 RD:1869771369 md114 LO:65536 CS:196610
Jul 31 04:12:11 libthumper1 kernel: md:     UT:00000000 ST:0 
AD:976767728 WD:0 FD:976767984 SD:0 CSUM:00000000 E:00000000
Jul 31 04:12:11 libthumper1 kernel:      D  0:  DISK<N:-1,(-1,-1),R:-1,S:-1>
Jul 31 04:12:11 libthumper1 kernel:      D  1:  DISK<N:-1,(-1,-1),R:-1,S:-1>
Jul 31 04:12:11 libthumper1 kernel:      D  2:  DISK<N:-1,(-1,-1),R:-1,S:-1>
Jul 31 04:12:11 libthumper1 kernel:      D  3:  DISK<N:-1,(-1,-1),R:-1,S:-1>
Jul 31 04:12:11 libthumper1 kernel: md:     THIS:  DISK<N:0,(0,0),R:0,S:0>
Jul 31 04:12:11 libthumper1 kernel: md: rdev superblock:
Jul 31 04:12:11 libthumper1 kernel: md:  SB: (V:1.0.0) 
ID:<be475f67.00000000.00000000.00000000> CT:81f4e22f
Jul 31 04:12:11 libthumper1 kernel: md:     L-2009873429 S1801675106 
ND:1834971253 RD:1869771369 md114 LO:65536 CS:196610
Jul 31 04:12:11 libthumper1 kernel: md:     UT:00000000 ST:0 
AD:976767728 WD:0 FD:976767984 SD:0 CSUM:00000000 E:00000000

<snip...and on and on>

Of course given how old the CentOS mdadm is, maybe by updating it I'll 
be fixing this problem as well?
If not, I'd be willing to help delve deeper if it's something worth 
investigating.

Again, Thanks a ton for all your help and quick replies!

Cheers!
-steve

> Thanks,
> NeilBrown
>
> diff --git a/super1.c b/super1.c
> index 35e92a3..4a3341a 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -803,6 +803,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>   		       __le64_to_cpu(sb->data_size));
>   	} else if (strcmp(update, "_reshape_progress")==0)
>   		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
> +	else if (strcmp(update, "summaries") == 0)
> +		sb->events = __cpu_to_le64(4);
>   	else
>   		rv = -1;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

