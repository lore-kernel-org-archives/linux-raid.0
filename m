From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Thu, 14 Aug 2003 10:24:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308141024.42208.arekm@pld-linux.org>
References: <200308131236.44311.arekm@pld-linux.org> <16186.61292.498656.959026@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16186.61292.498656.959026@gargle.gargle.HOWL>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >     Number   Major   Minor   RaidDevice State
> >        0       8        2        0      active sync   /dev/sda2
> >        1       8       18        1      faulty   /dev/sdb2
> >        2       0        0        2      faulty removed
> >        3       8       34        3      spare   /dev/sdc2
> >            UUID : c6839323:6d5bd707:731f0c8c:10e7b89b
> >          Events : 0.161
> >
> > I've removed sdb2 and readded it as spare. Of course that didn't
> > help.
>
> Ouch.  Looks like you had an error on /dev/sdb2.  Is there anything
> about that in the logs?
Error reported by md subsystem in kernel? Maybe I had (but that unlikely) - 
I'll check. Whole /dev/sdb device should be ok because I have part of 
/dev/md1 here, too (/dev/sdb3) and it's working fine.

> > I'm going to try ,,alternative method'' but I want to be sure of one
> > thing - if I recreate array with the same parameters I wont loose any
> > data on it?
>
> This is correct.  If you recreate the array with the same parameters
> you won't loose data.  Be sure to only include the up-to-date drives
> in the array when you first create it.  i.e. not /dev/sdc2.
I did that. Added /dev/sdc2 as missing but that didn't help. At beginning 
mdadm reported that /dev/sda2 and /dev/sdb2 are in sync, that here is another 
driver which failed. After adding /dev/sdc2 as spare is started resync but 
after finishing resyncing mdadm reported that both /dev/sdb2 and /dev/sdc2 
are failed :-( Tried that three times - always after getting into sync two 
drives was reported as failed.

So I recreated array with the same parameters but didn't add /dev/sdc2 as 
spare, copied all data and tried to create array from beginning using all 
these devices. Unfortunately after mdadm -C... it said that devices looks 
like from some array so I confirmed but... new array had /dev/sdc2 as failed 
:(

Why failed? - did it read that information from old superblock? If yes then I 
have feature request: avility to mdadm to erease old superblocks from 
cmdline.

No idea where that superblock resides on disk so I've tried to dd if=/dev/zero 
each /dev/sdX2 partition but that didn't help since I've dded only beginning 
of each partition and it seems that superblock is somewhere at end.

After creating raid1, mirror and few other types of raid on these /dev/sdX2 
partitions and then creating raid5 again I finally got working raid5 array 
where each disk is active sync! Hurray :)

Thanks for help!

> NeilBrown

