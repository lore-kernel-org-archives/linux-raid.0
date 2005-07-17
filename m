From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Failure
Date: Mon, 18 Jul 2005 08:05:04 +1000
Message-ID: <17114.54800.132155.142544@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, dstrang@shellpower.net wrote:
> -(root@abyss)-(/)- # mdadm --manage --add /dev/md0 /dev/sdaa
> mdadm: hot add failed for /dev/sdaa: Invalid argument
> 
> Jul 17 11:42:38 abyss kernel: md0: HOT_ADD may only be used with version-0 
> superblocks.
> 
> What, if anything, can I do since I'm using a version 1.0
> superblock?

Use a newer mdadm.  This works with v2.0-devel-2 (I just checked).

NeilBrown
