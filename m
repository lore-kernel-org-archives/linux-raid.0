From: "Matthew Carras" <matthew.carras@gmail.com>
Subject: Growing the underlying partitions in a raid5
Date: Tue, 3 Feb 2009 12:00:39 -0500
Message-ID: <4988783a.06045a0a.1e18.721e@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I've been reading up on growing a raid5 and all of the material seems to be
when you add a new partition. I don't have any new partitions to add, I just
have extra space on the original partitions. How do I go about growing the
size of sda4, sdb4, etc. so I can use parted on the raid5 to get its maximum
volume, all without destroying data? I tried setting one as faulty,
destroying it in fdisk then remaking it with a larger block size, and then
re-adding to the array, but the raid5 wouldn't accept it because it's too
big.

Matt


