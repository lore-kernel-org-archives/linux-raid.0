From: Neil Brown <neilb@suse.de>
Subject: Re: Growing a raid 6 array
Date: Fri, 2 Mar 2007 12:59:13 +1100
Message-ID: <17895.34033.867599.954940@notabene.brown>
References: <45E72549.2080108@unix-scripts.info>
	<Pine.LNX.4.64.0703011728270.7560@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Thursday March 1
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Laurent CARON <lcaron@unix-scripts.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 1, jpiszcz@lucidpixels.com wrote:
> You can only grow a RAID5 array in Linux as of 2.6.20 AFAIK.

There are two dimensions for growth.
You can increase the amount of each device that is used, or you can
increase the number of devices.

You are correct that increasing the number of devices only works for
RAID5 (and RAID1, but you don't get extra space) in 2.6.20 (RAID6
coming in 2.6.21).

However this question is about growing an array the first way:
increasing the amount of space used on each devices, and that is
supported for RAID1/4/5/6.

And Laurent:
  1/ Yes, it is that easy
  2/ I doubt a nearly-full ext3 array increases the risk
  3/ The effect of adding a bitmap is that if you suffer a crash while
     the array is degraded, it will resync faster so you have less
     exposure to multiple failure.

NeilBrown

