From: Neil Brown <neilb@suse.de>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks reporting
 "No md superblock detected"?
Date: Fri, 6 Feb 2009 16:14:56 +1100
Message-ID: <18827.51024.270348.20624@notabene.brown>
References: <1233775657.10151.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas J. Baker on Wednesday February 4
Sender: linux-raid-owner@vger.kernel.org
To: tjb@unh.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 4, tjb@unh.edu wrote:
> Any help greately appreciated. Here are the details:

Hmm.....

The limit on the number of devices in a 0.90 array is 27, despite the
fact that the manual page says '28'.

And the only limit that is enforced is that the number of raid_disks
is limited to 27.  So when you added a hot spare to your array, bad
things started happening.

I'd better fix that code and documentation.

But the issue at the moment is fixing your array.
It appears that all slots (0-26) are present except 
6,8,24

It seems likely that 
  6 is on sdh1
  8 is on sdj1
 24 is on sdz1 ... or sds1.   They seem to move around a bit.

If only 2 were missing you would be able to bring the array up.
But with 3 missing - not.

So we will need to recreate the array.  This should preserve all your
old data.

The command you will need is

mdadm --create /dev/md0 -l6 -n27  .... list of device names.....

Getting the correct list of device names is tricky, but quite possible
if you exercise due care.

The final list should have 27 entries, 2 of which should be the word
"missing".

When you do this it will create a degraded array.  As the array is
degraded, no resync will happen so the data on the arrays will not be
changed, only the metadata.

So if the list of devices turns out to be wrong, it isn't the end of
the world.  Just stop the array and try again with a different list.

So: how to get the list.
Start with the output of 
   ./examinRAIDDisks | grep -E '^(/dev|this)'

Based on your current output, the start of this will be:

                                  vvv
/dev/sdb1:
this     0       8       17        0      active sync   /dev/sdb1
/dev/sdc1:
this     1       8       33        1      active sync   /dev/sdc1
/dev/sdd1:
this     2       8       49        2      active sync   /dev/sdd1
/dev/sde1:
this     3       8       65        3      active sync   /dev/sde1
/dev/sdf1:
this     4       8       81        4      active sync   /dev/sdf1
/dev/sdg1:
this     5       8       97        5      active sync   /dev/sdg1
/dev/sdi1:
this     7       8      129        7      active sync   /dev/sdi1
/dev/sdk1:
this     9       8      161        9      active sync   /dev/sdk1
                                  ^^^

however if you have rebooted and particularly if you have moved any
drives, this could be different now.

The information that is important is the 
/dev/sdX1:
line and the 5th column of the other line, that I have highlighted.
Ignore the device name at the end of the lines (column 8), that is
just confusing.

The 5th column number tells you where in the array the /dev device
should live.
So from the above information, the first few devices in your list
would be

 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 missing
 /dev/sdi missing /dev/sdk1

If you follow this process on the complete output of the run, you will
get a list with 27 entries, 3 of which will be the word 'missing'.
You need to replace one of the 'missings' with a device that is not
listed, but probably goes at that place in the order
e.g. sdh1 in place of the first missing.

This command might help you

  ./examineRAIDDisks  |
   grep -E '^(/dev|this)'  | awk 'NF==1 {d=$1} NF==8 {print $5, d}' |
   sort -n | awk 'BEGIN {l=0} $1 != l+1 {print l+1, "missing" } {print; l = $1}'


If you use the --create command as describe above to create the array
you will probably have all your data accessible.  Use "fsck" or
whatever to check.  Do *not* add any other drives to the array until
you are sure that you are happy with the data that you have found.  If
it doesn't look right, try a different drive in place of the 'missing'

When you are happy, add two more drives to the array to get redundancy
back (it will have to recover the drives) but *do not* add any more
spares.  Leave it with a total of 27 devices.  If you add a spare, you
will have problems again.

If any of this isn't clear, please ask for clarification.

Good luck.

NeilBrown
