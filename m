From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 09:55:08 -0500
Message-ID: <6.2.5.6.2.20121112095127.039df8b0@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
 <50A06F9F.3090600@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A06F9F.3090600@websitemanagers.com.au>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
 <50A06F9F.3090600@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 02:40 PM 11/12/2012 +1100, Adam Goryachev wrote:
>5) madam --manage /dev/md2 --fail /dev/sdd (fail the disk you want to remove)
>6) mdadm --manage /dev/md2 --remove /dev/sdd (remove the disk from the array)

So this sequence will not harm the image
on the drive being roatated offsite?
Absolutely 100% for certain?  If there
is any chance of a problem I can
--stop the array before removing the
drive.  The volume is used for a Bacula
network backup that is often idle.

The third drive will never be on site
(think about the risk), but that just
means that the array will grow from
2->1 and then from 1->2 instead
of from 2->3 and 3->2.

