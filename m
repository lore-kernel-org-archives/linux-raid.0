From: Abhijit Bhopatkar <abhopatk@cisco.com>
Subject: Re: Potential race in dlm based messaging md-cluster.c
Date: Fri, 01 May 2015 00:21:52 +0530
Message-ID: <554279C8.6070305@cisco.com>
References: <CAE3Hb8oss1JZ2u7g7OQQgrEtgQ1vbQou04isiS6eEqbS=uzbhw@mail.gmail.com> <CAE3Hb8qNczD30RrcHFYCR90Jf9QFD-XH=x89MAu4Dpmm80se0A@mail.gmail.com> <554251EA.3000807@suse.com> <CAE3Hb8pJ=0MB6EX5jVch28gj-gnf0Mp1wyzxBfWjzLf=SuV4sQ@mail.gmail.com> <5542763C.90202@cisco.com> <554278CF.4000401@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <554278CF.4000401@cisco.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/05/15 12:17 am, Abhijit Bhopatkar wrote:
> On 01/05/15 12:06 am, Abhijit Bhopatkar wrote:
>> There is a possibility of a receiver losing out on messages in certain
>> corner conditions. One of the buggy case is if there is are two sender
>> ready with messages to be sent. Sender 1 initially gets the TOKEN lock
>> and proceeds.
>> After initial processing the sender of message 1 _will_ release TOKEN as
>> soon as receiver releases ACK, it does not wait till ACK CR is
>> re-acquired by receiver.
>>
> I could not come up with any solution except to add one more lock
> resource for now we will call it "SYNC"
>
Here is POC patch (completely untested only as an RFC not even compiled)
If the solution is agreed upon I will go ahead and test it.

Abhijit
---
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index fcfc4b9..addbbb4 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -62,6 +62,7 @@ struct md_cluster_info {
  	struct dlm_lock_resource *ack_lockres;
  	struct dlm_lock_resource *message_lockres;
  	struct dlm_lock_resource *token_lockres;
+	struct dlm_lock_resource *sync_lockres;
  	struct dlm_lock_resource *no_new_dev_lockres;
  	struct md_thread *recv_thread;
  	struct completion newdisk_completion;
@@ -94,7 +95,7 @@ static void sync_ast(void *arg)
  	complete(&res->completion);
  }
  
-static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
+static int dlm_lock_queue(struct dlm_lock_resource *res, int mode)
  {
  	int ret = 0;
  
@@ -102,12 +103,26 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
  	ret = dlm_lock(res->ls, mode, &res->lksb,
  			res->flags, res->name, strlen(res->name),
  			0, sync_ast, res, res->bast);
-	if (ret)
-		return ret;
+	return ret;
+}
+
+static int dlm_wait_for_lock_grant(struct dlm_lock_resource *res)
+{
  	wait_for_completion(&res->completion);
  	return res->lksb.sb_status;
  }
  
+static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
+{
+	int ret = 0;
+	ret = dlm_lock_queue(res,mode);
+
+	if (ret)
+		return ret;
+	ret = dlm_wait_for_lock_grant(res);
+	return ret;
+}
+
  static int dlm_unlock_sync(struct dlm_lock_resource *res)
  {
  	return dlm_lock_sync(res, DLM_LOCK_NL);
@@ -466,6 +481,7 @@ static void recv_daemon(struct md_thread *thread)
  	struct md_cluster_info *cinfo = thread->mddev->cluster_info;
  	struct dlm_lock_resource *ack_lockres = cinfo->ack_lockres;
  	struct dlm_lock_resource *message_lockres = cinfo->message_lockres;
+	struct dlm_lock_resource *sync_lockres = cinfo->sync_lockres;
  	struct cluster_msg msg;
  
  	/*get CR on Message*/
@@ -478,6 +494,9 @@ static void recv_daemon(struct md_thread *thread)
  	memcpy(&msg, message_lockres->lksb.sb_lvbptr, sizeof(struct cluster_msg));
  	process_recvd_msg(thread->mddev, &msg);
  
+	/*queue EX on TOKEN blocks new senders till we acquire CR on ACK */
+	dlm_lock_queue(sync_lockres,DLM_LOCK_EX);
+
  	/*release CR on ack_lockres*/
  	dlm_unlock_sync(ack_lockres);
  	/*up-convert to EX on message_lockres*/
@@ -486,6 +505,11 @@ static void recv_daemon(struct md_thread *thread)
  	dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
  	/*release CR on message_lockres*/
  	dlm_unlock_sync(message_lockres);
+
+	/*wait till EX on token is granted */
+	dlm_wait_for_lock_grant(token_lockres);
+	/*release EX on token_lockres*/
+	dlm_unlock_sync(sync_lockres);
  }
  
  /* lock_comm()
@@ -500,11 +524,16 @@ static int lock_comm(struct md_cluster_info *cinfo)
  	if (error)
  		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
  				__func__, __LINE__, error);
+	error = dlm_lock_sync(cinfo->sync_lockres, DLM_LOCK_EX);
+	if (error)
+		pr_err("md-cluster(%s:%d): failed to get EX on SYNC (%d)\n",
+				__func__, __LINE__, error);
  	return error;
  }
  
  static void unlock_comm(struct md_cluster_info *cinfo)
  {
+	dlm_unlock_sync(cinfo->sync_lockres);
  	dlm_unlock_sync(cinfo->token_lockres);
  }
  
@@ -673,6 +702,9 @@ static int join(struct mddev *mddev, int nodes)
  	cinfo->token_lockres = lockres_init(mddev, "token", NULL, 0);
  	if (!cinfo->token_lockres)
  		goto err;
+	cinfo->sync_lockres = lockres_init(mddev, "sync", NULL, 0);
+	if (!cinfo->sync_lockres)
+		goto err;
  	cinfo->ack_lockres = lockres_init(mddev, "ack", ack_bast, 0);
  	if (!cinfo->ack_lockres)
  		goto err;
@@ -711,6 +743,7 @@ static int join(struct mddev *mddev, int nodes)
  err:
  	lockres_free(cinfo->message_lockres);
  	lockres_free(cinfo->token_lockres);
+	lockres_free(cinfo->sync_lockres);
  	lockres_free(cinfo->ack_lockres);
  	lockres_free(cinfo->no_new_dev_lockres);
  	lockres_free(cinfo->bitmap_lockres);
@@ -733,6 +766,7 @@ static int leave(struct mddev *mddev)
  	md_unregister_thread(&cinfo->recv_thread);
  	lockres_free(cinfo->message_lockres);
  	lockres_free(cinfo->token_lockres);
+	lockres_free(cinfo->sync_lockres);
  	lockres_free(cinfo->ack_lockres);
  	lockres_free(cinfo->no_new_dev_lockres);
  	lockres_free(cinfo->sb_lock);

