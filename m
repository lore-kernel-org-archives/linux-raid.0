From: fibre raid <fibreraid@gmail.com>
Subject: Re: mdadm issue on Ubuntu Januty 9.04 server
Date: Wed, 13 May 2009 12:21:16 -0700
Message-ID: <5817fbed0905131221x623976d8i70080911bf8bde14@mail.gmail.com>
References: <5817fbed0905111832u35d39a5au52482cceea53a4cb@mail.gmail.com>
	 <f6ef7d922bea762a5b2539e4d015934a.squirrel@neil.brown.name>
	 <4A0AC7C0.1020507@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A0AC7C0.1020507@Calva.COM>
Sender: linux-raid-owner@vger.kernel.org
To: John Hughes <john@calva.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I updated my Jaunty installation to mdadm 2.6.9 and am noticing an
issue that I thought was solved in a prior release.

root@NIMBUS2cc0:~# mdadm --assemble /dev/md0
mdadm: metadata format 1.02 unknown, ignored.
mdadm: /dev/md0 has been started with 12 drives.


Why is it reporting the format 1.02 unknown, ignored? I have used the
-e 1.2 superblock command when creating the array, so I am not sure
where 1.02 is coming from.


root@NIMBUS2cc0:~# mdadm -D /dev/md0
mdadm: metadata format 1.02 unknown, ignored.
/dev/md0:
        Version : 1.02
  Creation Time : Wed May 13 18:49:27 2009
     Raid Level : raid0
     Array Size : 5860601856 (5589.11 GiB 6001.26 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May 13 18:49:27 2009
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : 0
           UUID : 3d67940f:afb6bf35:1836ba37:ef15a910
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8       97        5      active sync   /dev/sdg1
       6       8      113        6      active sync   /dev/sdh1
       7       8      129        7      active sync   /dev/sdi1
       8       8      145        8      active sync   /dev/sdj1
       9       8      161        9      active sync   /dev/sdk1
      10       8      177       10      active sync   /dev/sdl1
      11       8      193       11      active sync   /dev/sdm1


thanks!
-Thomas


On Wed, May 13, 2009 at 6:14 AM, John Hughes <john@calva.com> wrote:
> NeilBrown wrote:
>>
>> that make them look like part of some old array.
>> Why jaunty partially assembled them isn't clear. =A0Maybe it
>> is using --incremental and it is waiting for the rest of the
>> array to appear.
>>
>
> In my experience mdadm --incremental just doesn't work on Jaunty.
>
> When you run it on the first disk in the raid it sets the raid up as =
waiting
> for the rest, creates the /dev/md/xxx device, all looks good.
>
> When you try the second disk (I have a raid-1) it complains that the
> /dev/md/xxx exists and does nothing.
>
> Results - exactly as "fibre raid" complains - you're left with a part=
ly set
> up inactive raid.
>
> Haven't got around to doing a bugreport yet as I don't want to mess w=
ith my
> running server.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
