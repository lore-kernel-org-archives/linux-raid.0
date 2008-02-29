From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Severe slowdown with LVM on RAID, alignment =?UTF-8?Q?problem=3F?=
Date: Fri, 29 Feb 2008 11:45:51 +0100
Message-ID: <00d256ba72c4475569e7b68d7f1db6dd@localhost>
References: <47C7E086.5080203@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C7E086.5080203@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Peter

On Fri, 29 Feb 2008 11:37:58 +0100, Peter Rabbitson <rabbit+list@rabbit.us>
wrote:
> Michael Guntsche wrote:
> I would guess that you did not set the correct read-ahead values for the
> LV.
> If you do not specify anything it will default to 128k (256 sectors),
> which is
> terribly small for sequential reads. On the contrary the MD device will
do
> some clever calculations and set its read-ahead correctly depending on
the
> raid level and the number of disks. Do:
> 
> blockdev --setra 65536 <your lv device>
> 
> and run the tests again. You are almost certainly going to get the
results
> you
> are after.

I checked the read-ahead value on md0 (3072) and set this on the LV as
well.

Here is the result:

Version 1.03c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
lvm              8G           37251  25 27620  25           103996  49
160.0   2

I did not test it with the proper sunit,swdith values yet but the result is
now looking much better.
I'll play around with it some more this afternoon and post my result of
what is working best for me.
In the mean time, thank you all for your quick and helpful responses.


Kind regards,
Michael

