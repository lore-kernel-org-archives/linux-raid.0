From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Problem with RAID5 + ext3 expansion
Date: Sat, 23 Oct 2004 01:55:03 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410230555.i9N5t8N10622@www.watkins-home.com>
References: <200410230542.i9N5gRN10583@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410230542.i9N5gRN10583@www.watkins-home.com>
To: mailinglists-david@wasylciw.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found the warning!
"You must resize the partition now. The device that the partition on is now
about 500Gb, but the partition is still 250Gb. If you're partition is ext2
or ext3, you can use resize2fs. A word of caution for you. I've used this
utility many times, and it is necessary to do a e2fsck -f on the partition
to be resized BOTH before and after. The program itself will require you to
do it before. If you skip doing it after resize2fs completes, you will
almost assuredly ruin your filesystem. I've skipped the fsck after the
resize2fs myself 2-3 times, and it killed the filesystem every time.

TJ Harrell"

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Guy
Sent: Saturday, October 23, 2004 1:42 AM
To: mailinglists-david@wasylciw.com; linux-raid@vger.kernel.org
Subject: RE: Problem with RAID5 + ext3 expansion

You should test each disk with a command similar to this:
dd if=/dev/<disk> of=/dev/null bs=1024k
for <disk> use the full disk, not just a partition.
This is just a read test.
You can test all at the same time if you use different windows (xterms, or
whatever).

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Wasylciw
Sent: Saturday, October 23, 2004 1:25 AM
To: linux-raid@vger.kernel.org
Subject: Problem with RAID5 + ext3 expansion

Alright, so, I'm not sure if this is the right place to come to about this
problem but here's a overview of my setup:
6 x 250Gb IDE Hard Drives, generally I use evms and have a RAID5 array
built, with a lvm container on top of it and then my volumes. What I had
been trying to do was expand one of my ext3 volumes on top of the lvm, I had
taken it offline and evms was proceeding with the expansion, but then the
server locked up. Now, the reason I think this list might be the right spot
is that whenever I boot up it hangs after detecting the arraying and
beginning a sync. To troubleshoot I attempted to remove the md0 device and
recreate it with mdadm. Upon doing this it hung immediately. Mdadm reported
that the array still existed and that it would try to bring it online, at
that point it just hung. I didn't get a kernel panic error or anything just
a blank line.  Are there any logs that I should send along to the list or if
perhaps anyone has any ideas on what might have gone wrong/how to fix it?

Thanks,
David


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

