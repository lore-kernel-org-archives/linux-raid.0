From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Using raidreconf to create raid0 from non-raid works, but df is wrong
Date: Thu, 8 Jul 2004 09:42:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003a01c464f1$66198160$0201a8c0@windows>
References: <07ec01c46498$240dd770$6401010a@stan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Billings <mike@carolina.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You must resize the partition now. The device that the partition on is now
about 500Gb, but the partition is still 250Gb. If you're partition is ext2
or ext3, you can use resize2fs. A word of caution for you. I've used this
utility many times, and it is necessary to do a e2fsck -f on the partition
to be resized BOTH before and after. The program itself will require you to
do it before. If you skip doing it after resize2fs completes, you will
almost assuredly ruin your filesystem. I've skipped the fsck after the
resize2fs myself 2-3 times, and it killed the filesystem every time.

TJ Harrell


