From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Debugging new HW XOR engine driver
Date: Tue, 15 Jul 2008 23:48:46 -0700
Message-ID: <e9c3a7c20807152348p1f97066ar34921a28d8d38646@mail.gmail.com>
References: <504385.34173.qm@web81301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504385.34173.qm@web81301.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: thomas62186218@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 3:52 PM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am able to create a disk size of 40MB and mount it(mkfs.ext3 -b 4096 /dev/md0 10000). I was able to copy files to this mounted disk and read them back. If I increased the size more than 40MB file system if failing to mount.
>   Is it possible that data I have read/write was in page cache and never really written to Hard Disks  ?

What does the corruption look like?  Does it seem to be wrong data or
stale data?

> Is it safe to say RAID-5 is partially working ?

Without more information this sounds like the hw-xor driver is broken.
 What kernel version are you developing against?  You may want to take
a look at the dmatest client in async_tx/next [1].  It currently only
supports copy tests, but should exercise your driver's descriptor
processing routines.  When I tracked down bugs in iop-adma I used
raid5 as the test client and modified the kernel to do data
verification after each calculation in the ops_complete_* routines.
This requires userspace to use a predictable data pattern when writing
to the array.

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=next
