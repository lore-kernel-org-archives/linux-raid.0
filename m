From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: create raid5 with missing disk; not possible?
Date: Fri, 14 Jan 2005 16:05:34 -0500
Message-ID: <200501142103.j0EL3d911716@www.watkins-home.com>
References: <41E82CF6.2080203@avz.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E82CF6.2080203@avz.xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ferenc-Jan' <ferenc@avz.xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It should work!

I used your example, and everything worked as expected.
mdadm -C /dev/md3 -R -l5 -n4 /dev/ram0 /dev/ram1 /dev/ram2 missing

From mdadm -D /dev/md3:
    Number   Major   Minor   RaidDevice State
       0       1        0        0      active sync   /dev/ram0
       1       1        1        1      active sync   /dev/ram1
       2       1        2        2      active sync   /dev/ram2
       3       0        0        3      faulty

mdadm /dev/md3 -a /dev/ram3

From mdadm -D /dev/md3:
    Number   Major   Minor   RaidDevice State
       0       1        0        0      active sync   /dev/ram0
       1       1        1        1      active sync   /dev/ram1
       2       1        2        2      active sync   /dev/ram2
       3       0        0        3      faulty

       4       1        3        4      spare rebuilding   /dev/ram3

From cat /proc/mdatat:
md3 : active raid5 [dev 01:03][4] [dev 01:02][2] [dev 01:01][1] [dev
01:00][0]
      12096 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [>....................]  recovery =  0.0% (620/4032) finish=8.5min
speed=4K/sec

To slow things down I had run these 2 commands:
echo 1 > /proc/sys/dev/raid/speed_limit_min
echo 2 > /proc/sys/dev/raid/speed_limit_max

Otherwise, the re-sync would complete before I had a chance to type the next
command!

Once the re-sync was done, this is the outout from mdadm -D /dev/md3:
    Number   Major   Minor   RaidDevice State
       0       1        0        0      active sync   /dev/ram0
       1       1        1        1      active sync   /dev/ram1
       2       1        2        2      active sync   /dev/ram2
       3       1        3        3      active sync   /dev/ram3

I also tried without the "-R":
mdadm -C /dev/md3 -l5 -n4 /dev/ram0 /dev/ram1 /dev/ram2 missing
I had the same results with or without "-R".

I have Kernel 2.4.28 and mdadm 1.8.0.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ferenc-Jan
Sent: Friday, January 14, 2005 3:35 PM
To: linux-raid@vger.kernel.org
Subject: create raid5 with missing disk; not possible?

Hello,

I tried to create a raid5 set with 3 partitions and one missing device:

mdadm -C /dev/md1 -R -l5 -n4 /dev/hda3 /dev/hdc3 /dev/hdd3 missing

Later I want to add the fourth device with mdadm /dev/md1 -a /dev/hdb3. 
But this becomes a spare and I always end up with the missing drive in 
sync, mdadm -D /dev/md1:

<snip>
3       0        0        0      sync

I want to do this so I can use hdb to transfer data from an harddisk to 
the raid5 set. Maybe this is only possible with Raid 1 sets?

cheers

Ferenc
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

