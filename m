From: Chris Walker <cwalker@cray.com>
Subject: change in disk failure policy for non-BBL arrays?
Date: Mon, 23 Oct 2017 17:23:29 -0400
Message-ID: <ebc61f38-b401-c01a-5c2a-4671287f6eee@cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

We've noticed that for an array on which the bad block list has been 
disabled, a failed write from a 'check' operation no longer causes the 
offending disk to be failed out of the array.  As far as I can tell, 
this behavior changed with commit
https://github.com/torvalds/linux/commit/fc974ee2bffdde47d1e4b220cf326952cc2c4794, 
which adopted the block layer badblocks code and deprecated the 
MD-specific code.

It looks like this commit changed underlying code that adds a range of 
bad blocks to the BB table (md_set_badblocks --> badblocks_set) such 
that the sense of the return code reversed, from 0 meaning an error 
occurred to 0 meaning success, but the return code due to a disabled BB 
was left at 0.  With this change, therefore, for arrays without a BBL, 
calls to 'rdev_set_badblocks' changed from always a failure to always a 
success, and code such as

                                 if (rdev_set_badblocks(
                                             rdev,
r10_bio->devs[m].addr,
                                             r10_bio->sectors, 0))
                                         md_error(conf->mddev, rdev);

that previously would have failed the disk no longer do.  Was this 
change in policy deliberate?

Thanks,
Chris
