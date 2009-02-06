From: "Thomas J. Baker" <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks
 reporting "No md superblock detected"?
Date: Fri, 06 Feb 2009 15:32:05 -0500
Message-ID: <1233952325.9786.20.camel@localhost.localdomain>
References: <1233775657.10151.5.camel@localhost.localdomain>
	 <18827.51024.270348.20624@notabene.brown>
Reply-To: tjb@unh.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18827.51024.270348.20624@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2009-02-06 at 16:14 +1100, Neil Brown wrote:
> On Wednesday February 4, tjb@unh.edu wrote:
> > Any help greately appreciated. Here are the details:
> 
> Hmm.....
> 
> The limit on the number of devices in a 0.90 array is 27, despite the
> fact that the manual page says '28'.
> 
> And the only limit that is enforced is that the number of raid_disks
> is limited to 27.  So when you added a hot spare to your array, bad
> things started happening.
> 
> I'd better fix that code and documentation.
> 
> But the issue at the moment is fixing your array.
> It appears that all slots (0-26) are present except 
> 6,8,24
> 
> It seems likely that 
>   6 is on sdh1
>   8 is on sdj1
>  24 is on sdz1 ... or sds1.   They seem to move around a bit.
> 
> If only 2 were missing you would be able to bring the array up.
> But with 3 missing - not.
> 
> So we will need to recreate the array.  This should preserve all your
> old data.
> 
> The command you will need is
> 
> mdadm --create /dev/md0 -l6 -n27  .... list of device names.....
> 
> Getting the correct list of device names is tricky, but quite possible
> if you exercise due care.
> 
> The final list should have 27 entries, 2 of which should be the word
> "missing".
> 
> When you do this it will create a degraded array.  As the array is
> degraded, no resync will happen so the data on the arrays will not be
> changed, only the metadata.
> 
> So if the list of devices turns out to be wrong, it isn't the end of
> the world.  Just stop the array and try again with a different list.
> 
> So: how to get the list.
> Start with the output of 
>    ./examinRAIDDisks | grep -E '^(/dev|this)'
> 
> Based on your current output, the start of this will be:
> 
>                                   vvv
> /dev/sdb1:
> this     0       8       17        0      active sync   /dev/sdb1
> /dev/sdc1:
> this     1       8       33        1      active sync   /dev/sdc1
> /dev/sdd1:
> this     2       8       49        2      active sync   /dev/sdd1
> /dev/sde1:
> this     3       8       65        3      active sync   /dev/sde1
> /dev/sdf1:
> this     4       8       81        4      active sync   /dev/sdf1
> /dev/sdg1:
> this     5       8       97        5      active sync   /dev/sdg1
> /dev/sdi1:
> this     7       8      129        7      active sync   /dev/sdi1
> /dev/sdk1:
> this     9       8      161        9      active sync   /dev/sdk1
>                                   ^^^
> 
> however if you have rebooted and particularly if you have moved any
> drives, this could be different now.
> 
> The information that is important is the 
> /dev/sdX1:
> line and the 5th column of the other line, that I have highlighted.
> Ignore the device name at the end of the lines (column 8), that is
> just confusing.
> 
> The 5th column number tells you where in the array the /dev device
> should live.
> So from the above information, the first few devices in your list
> would be
> 
>  /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 missing
>  /dev/sdi missing /dev/sdk1
> 
> If you follow this process on the complete output of the run, you will
> get a list with 27 entries, 3 of which will be the word 'missing'.
> You need to replace one of the 'missings' with a device that is not
> listed, but probably goes at that place in the order
> e.g. sdh1 in place of the first missing.
> 
> This command might help you
> 
>   ./examineRAIDDisks  |
>    grep -E '^(/dev|this)'  | awk 'NF==1 {d=$1} NF==8 {print $5, d}' |
>    sort -n | awk 'BEGIN {l=0} $1 != l+1 {print l+1, "missing" } {print; l = $1}'
> 
> 
> If you use the --create command as describe above to create the array
> you will probably have all your data accessible.  Use "fsck" or
> whatever to check.  Do *not* add any other drives to the array until
> you are sure that you are happy with the data that you have found.  If
> it doesn't look right, try a different drive in place of the 'missing'
> 
> When you are happy, add two more drives to the array to get redundancy
> back (it will have to recover the drives) but *do not* add any more
> spares.  Leave it with a total of 27 devices.  If you add a spare, you
> will have problems again.
> 
> If any of this isn't clear, please ask for clarification.
> 
> Good luck.
> 
> NeilBrown

Thanks for the info. I think I follow everything. One last question
before really trying it - is this what is expected when I actually run
the command - the warnings about previous array, etc? 

[root@node002 ~]# ./recoverRAID 
mdadm --create /dev/md0 --verbose --level=6
--raid-devices=27 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 missing /dev/sdi1 missing /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1 /dev/sdp1 /dev/sdq1 /dev/sdr1 missing /dev/sdt1 /dev/sdu1
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 64K
mdadm: /dev/sdb1 appears to contain an ext2fs file system
    size=-295395124K  mtime=Fri Nov 20 19:36:27 1931
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdc1 appears to contain an ext2fs file system
    size=-1265904192K  mtime=Tue Dec 23 15:07:10 2008
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sde1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdf1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdg1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdi1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdk1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdl1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdm1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdn1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdo1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdw1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdx1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdy1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdz1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdaa1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdab1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdac1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdp1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdq1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdr1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdt1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: /dev/sdu1 appears to contain an ext2fs file system
    size=-1265903936K  mtime=Sun Mar  1 20:48:00 2009
mdadm: /dev/sdu1 appears to be part of a raid array:
    level=raid6 devices=27 ctime=Thu Jun 28 05:16:13 2007
mdadm: size set to 292961216K
Continue creating array? n
mdadm: create aborted.
[root@node002 ~]# 

Thanks,

tjb
-- 
=======================================================================
| Thomas Baker                                  email: tjb@unh.edu    |
| Systems Programmer                                                  |
| Research Computing Center                     voice: (603) 862-4490 |
| University of New Hampshire                     fax: (603) 862-1761 |
| 332 Morse Hall                                                      |
| Durham, NH 03824 USA              http://wintermute.sr.unh.edu/~tjb |
=======================================================================

