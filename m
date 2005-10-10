From: <drtyc@centrum.cz>
Subject: softraid growing?
Date: Mon, 10 Oct 2005 20:03:37 +0200
Message-ID: <200510102003.29996@centrum.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

Right now looking at drivers/md/md.c (linux-2.6.12.3) at:

static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
{
 int rv = 0;
 int cnt = 0;

 if (mddev->major_version != info->major_version ||
 mddev->minor_version != info->minor_version ||
/* mddev->patch_version != info->patch_version || */
 mddev->ctime != info->ctime ||
 mddev->level != info->level ||
/* mddev->layout != info->layout || */
 !mddev->persistent != info->not_persistent||
 mddev->chunk_size != info->chunk_size )
 return -EINVAL;
 /* Check there is only one change */
 if (mddev->size != info->size) cnt++;
 if (mddev->raid_disks != info->raid_disks) cnt++;
 if (mddev->layout != info->layout) cnt++;
 if (cnt == 0) return 0;
 if (cnt > 1) return -EINVAL;

... more update_array_info code

and asking myself why does it look like that resizing soft raid is not supported by this kernel.

mdadm had problems growing and in dmesg i found:
md: couldn't update array info. -22

This happened while trying to grow raid10.
raid10 device contains lvm with 2 non-available lv and consists of 1 nonallocate pv which is raid10 device

And I am wondering which kernel does have most recent code which supports to some degree soft raid growing.

I come across this issue while testing setup of disks overlaid with lvm to simulate flexible partitions overlaid by raid10(/tmp /var /incoming /home) & raid5(/ /data) & raid6 (/home2) used as PV for lvm to serve as container for different filesystems.

