From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] md-cluster: Fix adding of new disk with new reload code
Date: Wed, 26 Apr 2017 22:59:40 +0300
Message-ID: <20170426195940.l64pymopsbv36o7e@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Goldwyn Rodrigues,

The patch dbb64f8635f5: "md-cluster: Fix adding of new disk with new
reload code" from Oct 1, 2015, leads to the following static checker
warning:

	drivers/md/md-cluster.c:1341 add_new_disk()
	warn: inconsistent returns 'cinfo->recv_mutex'.
	  Locked on  : 1315,1341
	  Unlocked on: 1341

drivers/md/md-cluster.c
  1300  static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
  1301  {
  1302          struct md_cluster_info *cinfo = mddev->cluster_info;
  1303          struct cluster_msg cmsg;
  1304          int ret = 0;
  1305          struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
  1306          char *uuid = sb->device_uuid;
  1307  
  1308          memset(&cmsg, 0, sizeof(cmsg));
  1309          cmsg.type = cpu_to_le32(NEWDISK);
  1310          memcpy(cmsg.uuid, uuid, 16);
  1311          cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
  1312          lock_comm(cinfo, 1);
                ^^^^^^^^^^^^^^^^^^^
We take the lock here.

  1313          ret = __sendmsg(cinfo, &cmsg);
  1314          if (ret)
  1315                  return ret;

Should we unlock on failure here?

  1316          cinfo->no_new_dev_lockres->flags |= DLM_LKF_NOQUEUE;
  1317          ret = dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_EX);
  1318          cinfo->no_new_dev_lockres->flags &= ~DLM_LKF_NOQUEUE;
  1319          /* Some node does not "see" the device */
  1320          if (ret == -EAGAIN)
  1321                  ret = -ENOENT;
  1322          if (ret)
  1323                  unlock_comm(cinfo);

Because we do here.  I think we're only supposed to hold the lock on
success but how this all works with cancel etc looked slightly
complicated so I decided to ask instead of sending a patch.

  1324          else {
  1325                  dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
  1326                  /* Since MD_CHANGE_DEVS will be set in add_bound_rdev which
  1327                   * will run soon after add_new_disk, the below path will be
  1328                   * invoked:
  1329                   *   md_wakeup_thread(mddev->thread)
  1330                   *      -> conf->thread (raid1d)
  1331                   *      -> md_check_recovery -> md_update_sb
  1332                   *      -> metadata_update_start/finish
  1333                   * MD_CLUSTER_SEND_LOCKED_ALREADY will be cleared eventually.
  1334                   *
  1335                   * For other failure cases, metadata_update_cancel and
  1336                   * add_new_disk_cancel also clear below bit as well.
  1337                   * */
  1338                  set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
  1339                  wake_up(&cinfo->wait);
  1340          }
  1341          return ret;
  1342  }

regards,
dan carpenter
