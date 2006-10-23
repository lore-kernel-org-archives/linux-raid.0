From: Neil Brown <neilb@suse.de>
Subject: Re: Bug with RAID1 hot spares?
Date: Mon, 23 Oct 2006 14:13:36 +1000
Message-ID: <17724.16752.217048.956115@cse.unsw.edu.au>
References: <200610202046.43033.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chase Venters on Friday October 20
Sender: linux-raid-owner@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-raid@vger.kernel.org, jason.meinzer@gmail.com
List-Id: linux-raid.ids

On Friday October 20, chase.venters@clientec.com wrote:
> Greetings,
> 	I was just testing a server I was about to send into production on kernel 
> 2.6.18.1. The server has three SCSI disks with "md1" set to a RAID1 with 2 
> mirrors and 1 spare. The mirrors are sda3 and sdb3, spare is sdc3. I manually 
> failed sdb3, and as expected, sdc3 was activated. Strangely 
> enough, /proc/mdstat did not indicate that sdc3 was being synced. I thought 
> these spares weren't kept mirrored until needed?

Correct.  They are not kept mirrored.

> 	So there's definitely something odd happening here... why did no resync to 
> the sdc3 spare start when I failed sdb3?

yes... can you check that this fixes it please?
Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-10-23 12:09:08.000000000 +1000
+++ ./drivers/md/md.c	2006-10-23 14:10:46.000000000 +1000
@@ -2003,6 +2003,7 @@ static mdk_rdev_t *md_import_device(dev_
 	kobject_init(&rdev->kobj);
 
 	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;
