From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Failure
Date: Mon, 18 Jul 2005 10:06:52 +1000
Message-ID: <17114.62108.319878.983091@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
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
> Neil -
> 
> -(root@abyss)-(/)- # mdadm --manage -add /dev/md0 /dev/sdaa
> mdadm: hot add failed for /dev/sdaa: Invalid argument
> -(root@abyss)-(/)- # mdadm --version
> mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 2005
> -(root@abyss)-(/)- #
> 
> Jul 17 19:13:57 abyss kernel: md0: HOT_ADD may only be used with version-0 
> superblocks.
> 
> I'm using the devel-2 version, with the patch you posted previously.

That's really odd, because the only time mdadm-2 uses HOT_ADD_DISK is
inside an
  if (array.major_version == 0)
statement.

Are you any good with 'gdb'?
Could you try running mdadm under gdb, put a break point at
'Manage_subdevs', then step through from there and see what happens?

Print the value of 'array' after the GET_ARRAY_INFO ioctl, and then
keep stepping through until the error occurs..

NeilBrown
