From: "David Wasylciw" <mailinglists-david@wasylciw.com>
Subject: RE: Problem with RAID5 + ext3 expansion
Date: Sun, 24 Oct 2004 14:41:15 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0MKz5u-1CLmMl2d62-000794@mrelay.perfora.net>
References: <200410230542.i9N5gRN10583@www.watkins-home.com>
Reply-To: <mailinglists-david@wasylciw.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410230542.i9N5gRN10583@www.watkins-home.com>
To: 'Guy' <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I ran that test on each drive but all checked out just fine. What should I
do now? 

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Guy
Sent: Saturday October 23, 2004 2:42 AM
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
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html


