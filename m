From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Raid5 Failure
Date: Sun, 17 Jul 2005 20:52:07 -0400
Message-ID: <010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH><17114.54800.132155.142544@cse.unsw.edu.au><00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH> <17114.62108.319878.983091@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not real good with GDB... but I'm giving it a shot.

(gdb) run -a /dev/md0 /dev/sdaa
Starting program: /sbin/mdadm -a /dev/md0 /dev/sdaa
warning: Unable to find dynamic linker breakpoint function.
GDB will be unable to debug shared library initializers
and track explicitly loaded dynamic code.

Breakpoint 1, Manage_subdevs (devname=0xbfe75e5f "/dev/md0", fd=7, 
devlist=0x8067018) at Manage.c:174
174             void *dsuper = NULL;
(gdb) c
Continuing.
mdadm: hot add failed for /dev/sdaa: Invalid argument

Program exited with code 01.
(gdb)


-- David M. Strang

----- Original Message ----- 
From: Neil Brown
To: David M. Strang
Cc: linux-raid@vger.kernel.org
Sent: Sunday, July 17, 2005 8:06 PM
Subject: Re: Raid5 Failure


On Sunday July 17, dstrang@shellpower.net wrote:
> Neil -
>
> -(root@abyss)-(/)- # mdadm --manage -add /dev/md0 /dev/sdaa
> mdadm: hot add failed for /dev/sdaa: Invalid argument
> -(root@abyss)-(/)- # mdadm --version
> mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 
> 2005
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

