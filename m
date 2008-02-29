From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Severe slowdown with LVM on RAID, alignment =?UTF-8?Q?problem=3F?=
Date: Fri, 29 Feb 2008 09:12:01 +0100
Message-ID: <872d9b69db95a1b08319e935595743cc@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Fri, 29 Feb 2008 00:53:06 -0700, Maurice Hilarius <maurice@harddata.com>
wrote:
> Michael Guntsche wrote:
>> ..
>> While the result for XFS is different, reading is actually faster, the
>> differnece between xfs and xfs on lvm is still there.
>>
>>
> Great. At least now the figures are more realistic.

>> pvcreate was called so that the first PE starts exactly at 256K, no
sunits
>> where used with mkfs.xfs for the lvm case.
>>
>> I still do not understand the read output at all.
>>
> That is certainly a puzzle.

Is it possible that my computer is just too slow to get good read results?
I wonder since writing seems to be nearly similar.
I just tried with an ext3 FS.

Version 1.03c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
lvm-al8g-ext3    8G           45029  27 22436  29           55034  45 192.0
 3

While reading is a little bit faster it's nowhere near the speed I get on
md0 itself.

Kind regards,
Michael

