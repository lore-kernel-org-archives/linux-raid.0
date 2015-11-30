From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH V3 2/2] md-cluster: Protect communication with mutexes
Date: Mon, 30 Nov 2015 23:09:59 +0800
Message-ID: <565C66C7.3090004@suse.com>
References: <1448787432-4138-2-git-send-email-gqjiang@suse.com> <1448818989-8280-1-git-send-email-gqjiang@suse.com> <87mvtw5mm6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mvtw5mm6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

Hi Neil,

On 11/30/2015 08:58 AM, NeilBrown wrote:
> On Mon, Nov 30 2015, Guoqing Jiang wrote:
>
>> +#define		MD_CLUSTER_SEND_LOCK			4
>> +/* If cluster operations must lock the communication channel,
>> + * so as to perform extra operations (and no other operation
>> + * is allowed on the MD, such as adding a disk. Token needs
>> + * to be locked and held until the operation completes with
>> + * a md_update_sb(), which would eventually release the lock.
>> + */
> This comment has unbalanced parentheses.  How did it even compile :-)
Oops, thanks for catch that, how careless I am.
> But there is something else that isn't as clear as it could be....
>
>>   
>> @@ -970,14 +1019,18 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
>>   		ret = -ENOENT;
>>   	if (ret)
>>   		unlock_comm(cinfo);
>> -	else
>> +	else {
>>   		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
>> +		set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
>> +		wake_up(&cinfo->wait);
>> +	}
> This code suggests that something has caused a metadata update to be
> triggered.  i.e. something set MD_CHANGE_DEVS or similar.
> That is presumably add_bound_rdev() - which hasn't yet been called, but
> while soon after in add_new_disk().
>
> This feels a little bit fragile.  The new code in md-cluster is only
> correct if code in add_new_disk does a particular thing.  I guess I'd at
> least like to see a comment in add_new_disk() in md-cluster explaining
> what will cause MD_CLUSTE_SEND_LOCKED_ALREADY to eventually be cleared.
> Maybe it could also schedule the MD_CHANGE_DEVS to be completely certain
> that will happen, but that probably isn't necessary.
>
> So I've applied these for now, but if you could fix one comment and add
> another that would help.
What about the following changes? Thanks a lot.

[PATCH] md-cluster: comments update for MD_CLUSTER_SEND_LOCKED_ALREADY

1. fix unbalanced parentheses.
2. add more description about that MD_CLUSTER_SEND_LOCKED_ALREADY
    will be cleared after set it in add_new_disk.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
  drivers/md/md-cluster.c | 16 +++++++++++++---
  1 file changed, 13 insertions(+), 3 deletions(-)
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ad3ec7d..68b4866 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -53,9 +53,9 @@ struct resync_info {
   * accomodate lock and hold. See next comment.
   */
  #define                MD_CLUSTER_SEND_LOCK                    4
-/* If cluster operations must lock the communication channel,
- * so as to perform extra operations (and no other operation
- * is allowed on the MD, such as adding a disk. Token needs
+/* If cluster operations (such as adding a disk) must lock
+ * the communication channel, so as to perform extra operations
+ * and no other operation is allowed on the MD. Token needs
   * to be locked and held until the operation completes with
   * a md_update_sb(), which would eventually release the lock.
   */
@@ -1021,6 +1021,16 @@ static int add_new_disk(struct mddev *mddev, 
struct md_rdev *rdev)
                 unlock_comm(cinfo);
         else {
                 dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
+                /* Since MD_CHANGE_DEVS will be set in add_bound_rdev which
+                 * will run soon after add_new_disk, the path will be 
invoked:
+                 *   md_wakeup_thread(mddev->thread) -> conf->thread 
(raid1d)
+                 *                     -> md_check_recovery -> md_update_sb
+                 *                     -> metadata_update_start/finish
+                 * MD_CLUSTER_SEND_LOCKED_ALREADY will be cleared 
eventually.
+                 *
+                 * For other failure cases, metadata_update_cancel and
+                 * add_new_disk_cancel also clear below bit as well.
+                 */
                 set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
                 wake_up(&cinfo->wait);
         }
-- 
2.1.4

Guoqing
