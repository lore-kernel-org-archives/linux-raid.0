From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Did I make a mistake?
Date: Thu, 19 May 2011 21:45:23 -0500
Message-ID: <D8.84.03893.CB5D5DD4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	OK, I may have made an error, and I want to make sure before this
goes any further.  Yesterday I created a RAID6 volume with eight 3TB
members, on the same machine containing an older RAID6 array built of
fourteen 1G members.  Based upon my reading here and some level of
experience with larger stripe sizes, I decided to create the array with a
chunk size of 4096K.  The array from which I am copying all the data to this
new array was created with a chunk size of 256K.  It has decent performance.
I also created an array for the backup server with a 1024K chunk.  It seems
to perform even better, especially for writes.  Given this, I decided to
create the new array with a 4096K chunk.  All three arrays are formatted
with XFS, but when I formatted the new array, mkfs.xfs complained that the
stripe size of 4096K was too large, the maximum it supports is 256K, and it
was adjusting the stripe size to 32K.  That doesn't sound too good.  I don't
recall a response like that when I formatted the other arrays.

	When I formatted the array, of course mdadm started syncing the
array.  In the past, this process has been slow, so I really wasn't
concerned about the array only reading about 20Mbps for the sync from each
drive.  I started copying the data over from the old array, and I was
expecting that process to run more quickly, but it, too is really slow.  I
can read from the new array at more than 240MBps - far more than the 1G link
to the LAN can handle, so I have no fears in that respect, but the copy from
the old array is dragging along at only around 15 MBps.  Of course I expect
the sync process to slow down the writes considerably, but by that much??  I
would think even with the sync going on, the machine should be able to write
more than 100MBps.  An FTP copy from the backup server does a little better,
but not much, at around 17MBps.  When I do this, the local copy and the sync
process both seem to slow to a crawl.

	At this rate, the copy is going to take about 11 days to complete.
That in and of itself does not bother me, but I don't want to get to the end
of the 11 days and find I need to start all over again.  Should I expect the
write performance to increase dramatically when the sync is done?  Would I
be well served to start over now and go with a smaller chunk size?  The man
page does not say the chink size cannot be changed with a --grow command,
but it doesn't explicitly say it can, either.  I seem to recall there is a
way to change the stripe size on XFS, as well, but if my memory serves, it
requires a special parameter be passed to the mount command every time the
volume is mounted.

