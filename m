From: "John Stoffel" <john@stoffel.org>
Subject: Re: 2.6.18-rc5-mm1 - bd_claim_by_disk oops
Date: Fri, 15 Sep 2006 16:41:31 -0400
Message-ID: <17675.4091.70128.82346@smtp.charter.net>
References: <17665.30996.679000.180156@smtp.charter.net>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <17665.30996.679000.180156@smtp.charter.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids



John> I got the following on 2.6.18-rc5-mm1 when trying to lvextend a
John> test logical volume that I had just created.  This came about
John> because I have been trying to expand some LVs on my system,
John> which are based on a VG ontop of an MD mirror pair.  It's an SMP
John> box too if that means anything.

John> device-mapper: table: 253:3: linear: dm-linear: Device lookup failed
John> device-mapper: ioctl: error adding target to table
John> device-mapper: table: 253:3: linear: dm-linear: Device lookup failed
John> device-mapper: ioctl: error adding target to table
John> device-mapper: table: 253:2: linear: dm-linear: Device lookup failed
John> device-mapper: ioctl: error adding target to table

There error I got was:

  # lvextend -v -L +1g /dev/data_vg/home_lv
    Finding volume group data_vg
    Archiving volume group "data_vg" metadata (seqno 16).
    Extending logical volume home_lv to 52.00 GB
    Creating volume group backup "/etc/lvm/backup/data_vg" (seqno 17).
    Found volume group "data_vg"
    Found volume group "data_vg"
    Loading data_vg-home_lv table
    device-mapper: reload ioctl failed: Invalid argument
    Failed to suspend home_lv

I've found a solution to this problem of NOT being able to use
'lvextend' on some LVM2 Logical Volumes (LV).  Basically, I had to
apply the following patch to 2.6.18-rc6-mm2 to get it to work
properly.  I don't know why this wasn't reported here to the kernel
people.

Thanks,
John

----------------------------------------------------------------------

If a matching bd_holder is found in bd_holder_list,
add_bd_holder() completes its job by just incrementing the reference count.
In this case, it should be considered as success but it used to return 'fail'
to let the caller free temporary bd_holder.
Fixed it to return success and free given object by itself.

Also, if either one of symlinking fails, the bd_holder should not
be added to the list so that it can be discarded later.
Otherwise, the caller will free bd_holder which is in the list.

This patch is neccessary only for -mm (later than 2.6.18-rc1-mm1).

 fs/block_dev.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -urp linux-2.6.18-rc5-mm1.orig/fs/block_dev.c linux-2.6.18-rc5-mm1/fs/block_dev.c
--- linux-2.6.18-rc5-mm1.orig/fs/block_dev.c	2006-09-11 19:33:35.000000000 -0400
+++ linux-2.6.18-rc5-mm1/fs/block_dev.c	2006-09-11 19:21:46.000000000 -0400
@@ -655,8 +655,8 @@ static void free_bd_holder(struct bd_hol
  * If there is no matching entry with @bo in @bdev->bd_holder_list,
  * add @bo to the list, create symlinks.
  *
- * Returns 0 if @bo was added to the list.
- * Returns -ve if @bo wasn't used by any reason and should be freed.
+ * Returns 0 if symlinks are created or already there.
+ * Returns -ve if something fails and @bo can be freed.
  */
 static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 {
@@ -669,7 +669,9 @@ static int add_bd_holder(struct block_de
 	list_for_each_entry(tmp, &bdev->bd_holder_list, list) {
 		if (tmp->sdir == bo->sdir) {
 			tmp->count++;
-			return -EEXIST;
+			/* We've already done what we need to do here. */
+			free_bd_holder(bo);
+			return 0;
 		}
 	}
 
@@ -682,7 +684,8 @@ static int add_bd_holder(struct block_de
 		if (ret)
 			del_symlink(bo->sdir, bo->sdev);
 	}
-	list_add_tail(&bo->list, &bdev->bd_holder_list);
+	if (ret == 0)
+		list_add_tail(&bo->list, &bdev->bd_holder_list);
 	return ret;
 }

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
