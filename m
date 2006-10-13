From: "Dan" <dan@korstad.net>
Subject: new features time-line
Date: Fri, 13 Oct 2006 16:53:20 -0500
Message-ID: <000a01c6ef12$0030b640$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am curious if there are plans for either of the following;
-RAID6 reshape
-RAID5 to RAID6 migration

Here is why I ask, and sorry for the length.

I have an aging RAID6 with eight 250G drives as a physical volume in a
volume group.  It is at about 80% capacity.  I have had a couple drives fail
and replaced them with 500G drives.  I plan to migrate the rest over time as
they drop out.  However this could be months or years.

I could just be patient and wait until I have replaced all the drives and
use the -G -z max  to grow the RAID to resize the array to the maximum
space.  But I could use the extra space sooner.

Since I already have the existing RAID (md0) as a physical volume in a
volume group, I though why not just use the other half of the drives and
create another RAID6 (md1) add that to the same volume group and so on as I
grow. md0 made from devices=/dev/sd[abcdefgh]1; md1 made from
devices=/dev/sd[abcdefgh]2; and so on (I could have the md number match the
partition number for aesthetics I suppose)...  

By doing this I further protect myself from possible bit error rate on
increasingly large drives.  So if there are suddenly three bit errors I have
a chance as long as they are not all on the same partition number.  Mdadm
will only kick out the bad partitions and not the whole drive. (I know I am
already doing RAID6, what are the chances of three!).

To get to my point, I would like to split the new half of the drives into a
new physical volume and would 'like' to try to start using some of the
drives before I have replace all the existing 250G drives.  If RAID6 reshape
was an option I could start once I have replaced at least three of the old
drives (built it as a RAID6 with one missing).  But it is not available,
yet.  Or, since RAID5 reshape is an option, I could again start when I have
replaced three (built it as a RAID5) than grow it to until I get to the
eighth drive and migrate to the final desired RAID6.  But that is not an
option, yet.

Thoughts?


