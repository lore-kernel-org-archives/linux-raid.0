From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 and adding disks
Date: Fri, 17 Sep 2004 16:40:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409172040.i8HKea318657@watkins-home.com>
References: <20040917172301.94428.qmail@web50103.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040917172301.94428.qmail@web50103.mail.yahoo.com>
To: 'Andrew McCready' <ajmccready@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

man raidreconf

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andrew McCready
Sent: Friday, September 17, 2004 1:23 PM
To: linux-raid@vger.kernel.org
Subject: raid5 and adding disks

Is it possible to add a disk to a raid5 array after
that array has been created? 

I just bought 3 disks that I plan to turn into a raid5
array, and I have two more disks in a raid0 array that
I'd like to add to it. The problem is that the raid0
has 6months worth of data on it, and I have no where
else to stick that data while building the raid5
array. I was hoping I could build a 3 disk raid5
array, move the files over, then add the 2 remaining
disks to the raid5 array.

Thanks, Andrew
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

