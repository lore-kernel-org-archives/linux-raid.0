From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Minor RAID-1 oddity... any way to fix?
Date: Thu, 04 Sep 2003 16:43:03 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F57A3D7.D3E77710@SteelEye.com>
References: <20030904203719.16703.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux@horizon.com wrote:
 
> md3 : active raid1 hde3[2] hdi3[1]
>       58612096 blocks [2/1] [_U]
>       [====>................]  recovery = 21.1% (12401216/58612096) finish=36.6min speed=20987K/sec

[snip]

> Notice that in md1 and md7, it took its usual drive number in sequence and is happy.
> In md3, it got bumped up to drive 2, leaving the drive 0 number unassigned.

This is normal. md puts spare drives in higher slots initially. When the
recovery is done, you'll see the drive move back to its usual slot 0.

--
Paul
