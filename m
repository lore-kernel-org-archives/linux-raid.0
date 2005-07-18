From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Failure
Date: Mon, 18 Jul 2005 12:15:02 +1000
Message-ID: <17115.4262.933192.235433@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
	<17114.62108.319878.983091@cse.unsw.edu.au>
	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
	<17115.149.130115.176372@cse.unsw.edu.au>
	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH>
	<17115.1749.370942.838069@cse.unsw.edu.au>
	<004b01c58b3a$8e26f910$c200a8c0@NCNF5131FTH>
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
> Neil --
> 
> That worked, the device has been added to the array. Now, I think the next 
> problem is my own ignorance.

It looks like your kernel is missing the following patch (dated 31st
may 2005).  You're near the bleeding edge working with version-1
superblocks (and I do thank you for being a guinea pig:-) and should
use an ultra-recent kernel if at all possible.

If you don't have the array mounted (or can unmount it safely) then
you might be able to convince it to start the rebuild with by setting
it read-only, then writable.
i.e
  mdadm --readonly /dev/md0
  mdadm --readwrite /dev/md0

alternately stop and re-assemble the array.

NeilBrown



-----------------------

Make sure recovery happens when add_new_disk is used for hot_add

Currently if add_new_disk is used to hot-add a drive to a degraded
array, recovery doesn't start ... because we didn't tell it to.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-05-31 13:40:35.000000000 +1000
+++ ./drivers/md/md.c	2005-05-31 13:40:34.000000000 +1000
@@ -2232,6 +2232,8 @@ static int add_new_disk(mddev_t * mddev,
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
 			export_rdev(rdev);
+
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		if (mddev->thread)
 			md_wakeup_thread(mddev->thread);
 		return err;
