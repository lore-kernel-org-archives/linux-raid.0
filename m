From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [bug report] md-cluster: Fix adding of new disk with new reload
 code
Date: Fri, 5 May 2017 17:30:29 -0500
Message-ID: <5dc69b82-cf52-f6e5-693e-daa4cada215e@suse.de>
References: <20170426195940.l64pymopsbv36o7e@mwanda>
 <59015CD0.3080505@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59015CD0.3080505@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/26/2017 09:52 PM, Guoqing Jiang wrote:
> HI,
> 
> Thanks for check.
> 
> On 04/27/2017 03:59 AM, Dan Carpenter wrote:
>> Hello Goldwyn Rodrigues,
>>
>> The patch dbb64f8635f5: "md-cluster: Fix adding of new disk with new
>> reload code" from Oct 1, 2015, leads to the following static checker
>> warning:
>>
>>     drivers/md/md-cluster.c:1341 add_new_disk()
>>     warn: inconsistent returns 'cinfo->recv_mutex'.
>>       Locked on  : 1315,1341
>>       Unlocked on: 1341
>>
>> drivers/md/md-cluster.c
>>    1300  static int add_new_disk(struct mddev *mddev, struct md_rdev
>> *rdev)
>>    1301  {
>>    1302          struct md_cluster_info *cinfo = mddev->cluster_info;
>>    1303          struct cluster_msg cmsg;
>>    1304          int ret = 0;
>>    1305          struct mdp_superblock_1 *sb =
>> page_address(rdev->sb_page);
>>    1306          char *uuid = sb->device_uuid;
>>    1307
>>    1308          memset(&cmsg, 0, sizeof(cmsg));
>>    1309          cmsg.type = cpu_to_le32(NEWDISK);
>>    1310          memcpy(cmsg.uuid, uuid, 16);
>>    1311          cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
>>    1312          lock_comm(cinfo, 1);
>>                  ^^^^^^^^^^^^^^^^^^^
>> We take the lock here.
>>
>>    1313          ret = __sendmsg(cinfo, &cmsg);
>>    1314          if (ret)
>>    1315                  return ret;
>>
>> Should we unlock on failure here?
> 
> I agree we may need the unlock here, since both add_new_disk_cancel and
> unlock_comm are not called for the failure case, it is not right.
> 
> But I think Goldwyn knows better, let's wait for his comment.

Yes, you are right. We should unlock here. Thanks.
Could you please send a patch?

> 
> 
>>    1316          cinfo->no_new_dev_lockres->flags |= DLM_LKF_NOQUEUE;
>>    1317          ret = dlm_lock_sync(cinfo->no_new_dev_lockres,
>> DLM_LOCK_EX);
>>    1318          cinfo->no_new_dev_lockres->flags &= ~DLM_LKF_NOQUEUE;
>>    1319          /* Some node does not "see" the device */
>>    1320          if (ret == -EAGAIN)
>>    1321                  ret = -ENOENT;
>>    1322          if (ret)
>>    1323                  unlock_comm(cinfo);
>>
>> Because we do here.  I think we're only supposed to hold the lock on
>> success but how this all works with cancel etc looked slightly
>> complicated so I decided to ask instead of sending a patch.
> 
> Please take a look with comments from L1326 to L1337, unlock will be
> called eventually by
> metadata_update_finish (for successful case) or
> metadata_update_cancel/add_new_disk_cancel
> (for failure case).
> 
>>
>>    1324          else {
>>    1325                  dlm_lock_sync(cinfo->no_new_dev_lockres,
>> DLM_LOCK_CR);
>>    1326                  /* Since MD_CHANGE_DEVS will be set in
>> add_bound_rdev which
>>    1327                   * will run soon after add_new_disk, the
>> below path will be
>>    1328                   * invoked:
>>    1329                   *   md_wakeup_thread(mddev->thread)
>>    1330                   *      -> conf->thread (raid1d)
>>    1331                   *      -> md_check_recovery -> md_update_sb
>>    1332                   *      -> metadata_update_start/finish
>>    1333                   * MD_CLUSTER_SEND_LOCKED_ALREADY will be
>> cleared eventually.
>>    1334                   *
>>    1335                   * For other failure cases,
>> metadata_update_cancel and
>>    1336                   * add_new_disk_cancel also clear below bit
>> as well.
>>    1337                   * */
>>    1338                  set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY,
>> &cinfo->state);
>>    1339                  wake_up(&cinfo->wait);
>>    1340          }
>>    1341          return ret;
>>    1342  }
>>
> 
> Regards,
> Guoqing

-- 
Goldwyn
