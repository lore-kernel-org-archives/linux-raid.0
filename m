From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Failure
Date: Mon, 18 Jul 2005 11:06:29 +1000
Message-ID: <17115.149.130115.176372@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
	<17114.62108.319878.983091@cse.unsw.edu.au>
	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
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
> I'm not real good with GDB... but I'm giving it a shot.
> 
> (gdb) run -a /dev/md0 /dev/sdaa
> Starting program: /sbin/mdadm -a /dev/md0 /dev/sdaa
> warning: Unable to find dynamic linker breakpoint function.
> GDB will be unable to debug shared library initializers
> and track explicitly loaded dynamic code.
> 
> Breakpoint 1, Manage_subdevs (devname=0xbfe75e5f "/dev/md0", fd=7, 
> devlist=0x8067018) at Manage.c:174
> 174             void *dsuper = NULL;
> (gdb) c

At this point you need to use 'n' for 'next', to step through the code
one statement at a time.
When you see:
 176          	  if (ioctl(fd, GET_ARRAY_INFO, &array)) {
enter 'n' again, to execute that, then
  print array
to print the 'array' structure.
Then continue with 'n' repeatedly.

NeilBrown
