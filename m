From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 14:23:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400D1DA6.80509@upfrontsystems.co.za>
References: <400CD0BF.2010808@upfrontsystems.co.za> <16396.64514.820157.677722@notabene.cse.unsw.edu.au> <400D05AC.4030409@upfrontsystems.co.za> <200401201310.48900.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401201310.48900.maarten@vbvb.nl>
To: maarten@nebula.vbvb.nl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maarten

> So, maybe mount is right and /mnt/gentoo/raid/ IS actually wrong...?

I.e. the filesystem under RAID is corrupt? This is what I'm afraid of.

> So maybe more prudent would be a reiserfsck --check...

Oooh! Looks like something worked .. still can't mount though ..
should I try --rebuild-tree next? :

cdimage root # reiserfsck --check /dev/md0

<-------------reiserfsck, 2003------------->
reiserfsprogs 3.6.8

[...]
Will read-only check consistency of the filesystem on /dev/md0
Will put log info to 'stdout'

Do you want to run this program?[N/Yes] (note need to type Yes if you do):Yes
###########
reiserfsck --check started at Tue Jan 20 12:19:38 2004
###########
Replaying journal..
0 transactions replayed
Checking internal tree../  1 (of   2)/  1 (of 126)/  1 (of 153)block 8211: The 
level of the node (25938) is not correct, (1) expected
  the problem in the internal node occured (8211), whole subtree is skipped
finished
Comparing bitmaps..vpf-10640: The on-disk and the correct bitmaps differs.
Bad nodes were found, Semantic pass skipped
1 found corruptions can be fixed only during --rebuild-tree
###########
reiserfsck finished at Tue Jan 20 12:20:11 2004
###########
cdimage root # mount -r -t reiserfs /dev/md0 /mnt/gentoo/raid/
mount: Not a directory

(Apologies for direct mail but speed is of the essence .. )

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

