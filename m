From: Michael Guntsche <mike@it-loops.com>
Subject: Re: Severe slowdown with LVM on RAID, alignment =?UTF-8?Q?problem=3F?=
Date: Fri, 29 Feb 2008 08:37:44 +0100
Message-ID: <13b69e90155ddee52ada8df5a5ec416c@localhost>
References: <47C75436.9010301@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C75436.9010301@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 28 Feb 2008 17:39:18 -0700, Maurice Hilarius <maurice@harddata.com>
wrote:
> If you use bonnie++ with a file size of 1GB, I hope you only have 256MB
> of RAM in this machine.
> Otherwise buffering will horribly skew any results to the point that
> they are unusable

Thank you for the info. 
Currently I have 512MB RAM and 500MB SWAP in this box. I upped the size to
8GB, so 8 files a 1GB are created.
While the result for XFS is different, reading is actually faster, the
differnece between xfs and xfs on lvm is still there.

pvcreate was called so that the first PE starts exactly at 256K, no sunits
where used with mkfs.xfs for the lvm case.

I still do not understand the read output at all.

Version  1.03c      ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
xfs              8G           38876  25 28244  22           103891  40
161.4   2
lvm-al           8G           37089  24 18821  23           48489  40 155.8
  2

While it looks like that writing is actually pretty similar reading is
still way down.

Totally at loss here,
Michael







