From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: mdstat reporting (superblock & status side-by-side). Can it be changed
 ?
Date: Sun, 13 Sep 2015 12:58:25 -0500
Message-ID: <55F5B941.8050107@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

   After looking at the output of /proc/mdstat many times, there is one 'human 
factors' (human nature) bit of difficulty with the order of the output 
(especially with a standard 2-disk raid1 array and 1.2 superblock:

md1 : active raid1 sda7[2] sdb7[1]
       52396032 blocks super 1.2 [2/2] [UU]
                             ^^^^^^^^^

   When scanning the information quickly to insure you do NOT have 1/2 disks 
active in the array, you run into the version and disk information side-by-side.

   "1.2 [2/2]"

   Which naturally causes a short "huh?..., OK" double-take.

   Is there any way from a user standpoint (short of "read a b c d e f"; echo 
"$c $d $a $b $e $f"), to rearrange the order the information is reported as:

md1 : active raid1 sda7[2] sdb7[1]
       super 1.2 52396032 blocks [2/2] [UU]

   That simple change makes glancing down the right-side of the information much 
easier on the brain....

   I don't think this was ever a concern prior to the 1.2 superbock and I'm not 
sure it warrants any brainpower now. However, it was something that stood out to 
me, so I thought I would pass it along.

-- 
David C. Rankin, J.D.,P.E.
