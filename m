Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBDF13C8F3
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451777; cv=none; b=s/PwSrqyBlnXN3qpConOkWLCd9bEDdkibZ1rhtayb9G69vyTieyVC6+qOJFWnGUexeosKDpxLMiHFDJ2iCVTxcdP9+XEG7agN35kMiDhjZp8biGq4kWwa82yO163Rn12SKe3nLpjO1efTtOGu8aAVigVCEWRCKmMBKj2lRI+/qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451777; c=relaxed/simple;
	bh=bQgyFJxRt3FSm1nkiU1eTBIc3gDMKqeAIKxbLOB7Qak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDu2/hJeboJ463aKavaOhAFyiWdVyfOEeoYo/Ab5sxvVVNIGURK4IG231SnoDNYwTikz+2svbHN0JCldmIXun5q5tTtM+MjvXQpp87MZvtxUHtuonfrmm4iq/CiwJdFfZxSEeiqqYI1XealLKPS+sN6WqqnLYra1wrGXUQ+3ytg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RdjLCs0v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RdjLCs0v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2epsytguzINNeQ6HnKXGxOqPIWimQbqfsoKzl7ijpMs=;
	b=RdjLCs0v+dXXYaGLQBBEJOaWByW0CEIbEySMsL1cDeenuQDUzyjJ9d69urvEoQFLRnnBAN
	IxNEHBve3uVzZh3Z0yeX7gQj4WOtViqYkLtIZMKjsLlchcWu7DIRm1wIh3Kkt8OoyyDihf
	B1MhyPMN4zIyuLT2dHB0Ej1546mQAtc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-11NMoj-CO0KJhk0wHEMtoQ-1; Mon, 03 Jun 2024 17:56:09 -0400
X-MC-Unique: 11NMoj-CO0KJhk0wHEMtoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DA3F85A58C;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 907E5200E554;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 1/8] dlm: using rcu to avoid rsb lookup again
Date: Mon,  3 Jun 2024 17:55:51 -0400
Message-ID: <20240603215558.2722969-2-aahringo@redhat.com>
In-Reply-To: <20240603215558.2722969-1-aahringo@redhat.com>
References: <20240603215558.2722969-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

This patch converts the rsb to be protected under rcu. When the rcu lock
is held it cannot be freed. In combination with the new introduced flag
RSB_HASHED we can check if the rsb is still part of the ls_rsbtbl
hashtable, it cannot be part of another table. If its still part of the
ls_rsbtbl we can avoid a second dlm_search_rsb_tree() call.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/dlm_internal.h |   3 ++
 fs/dlm/lock.c         | 117 ++++++++++++++++++++++++++++++++++--------
 fs/dlm/memory.c       |  15 +++++-
 3 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 9e68e68bf0cf..6f578527c6d8 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -333,6 +333,7 @@ struct dlm_rsb {
 	struct list_head	res_recover_list;   /* used for recovery */
 	struct list_head	res_toss_q_list;
 	int			res_recover_locks_count;
+	struct rcu_head		rcu;
 
 	char			*res_lvbptr;
 	char			res_name[DLM_RESNAME_MAXLEN+1];
@@ -366,6 +367,8 @@ enum rsb_flags {
 	RSB_RECOVER_GRANT,
 	RSB_RECOVER_LVB_INVAL,
 	RSB_TOSS,
+	/* if rsb is part of ls_rsbtbl or not */
+	RSB_HASHED,
 };
 
 static inline void rsb_set_flag(struct dlm_rsb *r, enum rsb_flags flag)
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index a29de48849ef..e1e990b09068 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -582,6 +582,7 @@ void dlm_rsb_toss_timer(struct timer_list *timer)
 		list_del(&r->res_rsbs_list);
 		rhashtable_remove_fast(&ls->ls_rsbtbl, &r->res_node,
 				       dlm_rhash_rsb_params);
+		rsb_clear_flag(r, RSB_HASHED);
 
 		/* not necessary to held the ls_rsbtbl_lock when
 		 * calling send_remove()
@@ -658,8 +659,14 @@ int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
 
 static int rsb_insert(struct dlm_rsb *rsb, struct rhashtable *rhash)
 {
-	return rhashtable_insert_fast(rhash, &rsb->res_node,
-				      dlm_rhash_rsb_params);
+	int rv;
+
+	rv = rhashtable_insert_fast(rhash, &rsb->res_node,
+				    dlm_rhash_rsb_params);
+	if (!rv)
+		rsb_set_flag(rsb, RSB_HASHED);
+
+	return rv;
 }
 
 /*
@@ -773,12 +780,24 @@ static int find_rsb_dir(struct dlm_ls *ls, const void *name, int len,
 
  do_toss:
 	write_lock_bh(&ls->ls_rsbtbl_lock);
-
-	/* retry lookup under write lock to see if its still in toss state
-	 * if not it's in keep state and we relookup - unlikely path.
+	/* toss handling move to out of toss handling requires ls_rsbtbl_lock
+	 * to held in write lock state. However during the transition from
+	 * previously read lock state to write lock state the rsb can be
+	 * removed out of the ls_rsbtbl hash or change it's state to keep
+	 * state. If RSB_HASHED is not set anymore somebody else removed
+	 * the entry out of the ls_rsbtbl hash, the lookup is protected by
+	 * rcu read lock and is an rcu read critical section, a possible free
+	 * of a rsb (that usually occurs when a rsb is removed out of the hash)
+	 * cannot be done between the read to write lock state transition as
+	 * kfree_rcu() of rsb will not occur during this rcu read critical
+	 * section for this reason a check on if RSB_HASHED is enough to check
+	 * if this situation happened. The recheck on RSB_TOSS is required to
+	 * check if the rsb is still in toss state, because somebody else
+	 * could take it out of RSB_TOSS state. If this is the case we do a
+	 * relookup under read lock as this is a very unlikely case.
+	 * The RSB_HASHED case can happen and we need to be prepared for this.
 	 */
-	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
-	if (!error) {
+	if (rsb_flag(r, RSB_HASHED)) {
 		if (!rsb_flag(r, RSB_TOSS)) {
 			write_unlock_bh(&ls->ls_rsbtbl_lock);
 			goto retry;
@@ -950,11 +969,24 @@ static int find_rsb_nodir(struct dlm_ls *ls, const void *name, int len,
  do_toss:
 	write_lock_bh(&ls->ls_rsbtbl_lock);
 
-	/* retry lookup under write lock to see if its still in toss state
-	 * if not it's in keep state and we relookup - unlikely path.
+	/* toss handling move to out of toss handling requires ls_rsbtbl_lock
+	 * to held in write lock state. However during the transition from
+	 * previously read lock state to write lock state the rsb can be
+	 * removed out of the ls_rsbtbl hash or change it's state to keep
+	 * state. If RSB_HASHED is not set anymore somebody else removed
+	 * the entry out of the ls_rsbtbl hash, the lookup is protected by
+	 * rcu read lock and is an rcu read critical section, a possible free
+	 * of a rsb (that usually occurs when a rsb is removed out of the hash)
+	 * cannot be done between the read to write lock state transition as
+	 * kfree_rcu() of rsb will not occur during this rcu read critical
+	 * section for this reason a check on if RSB_HASHED is enough to check
+	 * if this situation happened. The recheck on RSB_TOSS is required to
+	 * check if the rsb is still in toss state, because somebody else
+	 * could take it out of RSB_TOSS state. If this is the case we do a
+	 * relookup under read lock as this is a very unlikely case.
+	 * The RSB_HASHED case can happen and we need to be prepared for this.
 	 */
-	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
-	if (!error) {
+	if (rsb_flag(r, RSB_HASHED)) {
 		if (!rsb_flag(r, RSB_TOSS)) {
 			write_unlock_bh(&ls->ls_rsbtbl_lock);
 			goto retry;
@@ -1046,6 +1078,7 @@ static int find_rsb(struct dlm_ls *ls, const void *name, int len,
 {
 	int dir_nodeid;
 	uint32_t hash;
+	int rv;
 
 	if (len > DLM_RESNAME_MAXLEN)
 		return -EINVAL;
@@ -1053,12 +1086,20 @@ static int find_rsb(struct dlm_ls *ls, const void *name, int len,
 	hash = jhash(name, len, 0);
 	dir_nodeid = dlm_hash2nodeid(ls, hash);
 
+	/* hold the rcu lock here to prevent freeing of the rsb
+	 * while looking it up, there are currently a optimization
+	 * to not lookup the rsb twice instead look if its still
+	 * part of the rsbtbl hash.
+	 */
+	rcu_read_lock();
 	if (dlm_no_directory(ls))
-		return find_rsb_nodir(ls, name, len, hash, dir_nodeid,
-				      from_nodeid, flags, r_ret);
-	else
-		return find_rsb_dir(ls, name, len, hash, dir_nodeid,
+		rv = find_rsb_nodir(ls, name, len, hash, dir_nodeid,
 				    from_nodeid, flags, r_ret);
+	else
+		rv = find_rsb_dir(ls, name, len, hash, dir_nodeid,
+				  from_nodeid, flags, r_ret);
+	rcu_read_unlock();
+	return rv;
 }
 
 /* we have received a request and found that res_master_nodeid != our_nodeid,
@@ -1215,8 +1256,9 @@ static void __dlm_master_lookup(struct dlm_ls *ls, struct dlm_rsb *r, int our_no
  * . dlm_master_lookup RECOVER_MASTER (fix_master 1, from_master 0)
  */
 
-int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
-		      int len, unsigned int flags, int *r_nodeid, int *result)
+static int _dlm_master_lookup(struct dlm_ls *ls, int from_nodeid,
+			      const char *name, int len, unsigned int flags,
+			      int *r_nodeid, int *result)
 {
 	struct dlm_rsb *r = NULL;
 	uint32_t hash;
@@ -1243,7 +1285,6 @@ int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
 	}
 
  retry:
-
 	/* check if the rsb is in keep state under read lock - likely path */
 	read_lock_bh(&ls->ls_rsbtbl_lock);
 	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
@@ -1278,11 +1319,24 @@ int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
 	/* unlikely path - relookup under write */
 	write_lock_bh(&ls->ls_rsbtbl_lock);
 
-	/* rsb_mod_timer() requires to held ls_rsbtbl_lock in write lock
-	 * check if the rsb is still in toss state, if not relookup
+	/* toss handling move to out of toss handling requires ls_rsbtbl_lock
+	 * to held in write lock state. However during the transition from
+	 * previously read lock state to write lock state the rsb can be
+	 * removed out of the ls_rsbtbl hash or change it's state to keep
+	 * state. If RSB_HASHED is not set anymore somebody else removed
+	 * the entry out of the ls_rsbtbl hash, the lookup is protected by
+	 * rcu read lock and is an rcu read critical section, a possible free
+	 * of a rsb (that usually occurs when a rsb is removed out of the hash)
+	 * cannot be done between the read to write lock state transition as
+	 * kfree_rcu() of rsb will not occur during this rcu read critical
+	 * section for this reason a check on if RSB_HASHED is enough to check
+	 * if this situation happened. The recheck on RSB_TOSS is required to
+	 * check if the rsb is still in toss state, because somebody else
+	 * could take it out of RSB_TOSS state. If this is the case we do a
+	 * relookup under read lock as this is a very unlikely case.
+	 * The RSB_HASHED case can happen and we need to be prepared for this.
 	 */
-	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
-	if (!error) {
+	if (rsb_flag(r, RSB_HASHED)) {
 		if (!rsb_flag(r, RSB_TOSS)) {
 			write_unlock_bh(&ls->ls_rsbtbl_lock);
 			/* something as changed, very unlikely but
@@ -1290,6 +1344,7 @@ int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
 			 */
 			goto retry;
 		}
+
 	} else {
 		write_unlock_bh(&ls->ls_rsbtbl_lock);
 		goto not_found;
@@ -1346,6 +1401,23 @@ int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
 	return error;
 }
 
+int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
+		      int len, unsigned int flags, int *r_nodeid, int *result)
+{
+	int rv;
+
+	/* hold the rcu lock here to prevent freeing of the rsb
+	 * while looking it up, there are currently a optimization
+	 * to not lookup the rsb twice instead look if its still
+	 * part of the rsbtbl hash.
+	 */
+	rcu_read_lock();
+	rv = _dlm_master_lookup(ls, from_nodeid, name, len, flags, r_nodeid,
+				result);
+	rcu_read_unlock();
+	return rv;
+}
+
 static void dlm_dump_rsb_hash(struct dlm_ls *ls, uint32_t hash)
 {
 	struct dlm_rsb *r;
@@ -4308,6 +4380,7 @@ static void receive_remove(struct dlm_ls *ls, const struct dlm_message *ms)
 	list_del(&r->res_rsbs_list);
 	rhashtable_remove_fast(&ls->ls_rsbtbl, &r->res_node,
 			       dlm_rhash_rsb_params);
+	rsb_clear_flag(r, RSB_HASHED);
 	write_unlock_bh(&ls->ls_rsbtbl_lock);
 
 	free_toss_rsb(r);
diff --git a/fs/dlm/memory.c b/fs/dlm/memory.c
index 15a8b1cee433..d6cb7a1c700d 100644
--- a/fs/dlm/memory.c
+++ b/fs/dlm/memory.c
@@ -101,13 +101,26 @@ struct dlm_rsb *dlm_allocate_rsb(struct dlm_ls *ls)
 	return r;
 }
 
-void dlm_free_rsb(struct dlm_rsb *r)
+static void __dlm_free_rsb(struct rcu_head *rcu)
 {
+	struct dlm_rsb *r = container_of(rcu, struct dlm_rsb, rcu);
+
 	if (r->res_lvbptr)
 		dlm_free_lvb(r->res_lvbptr);
 	kmem_cache_free(rsb_cache, r);
 }
 
+void dlm_free_rsb(struct dlm_rsb *r)
+{
+	/* wait until all current rcu read critical sections
+	 * are done until calling __dlm_free_rsb. Currently
+	 * this is used to avoid an use after free when checking
+	 * of the rsb is still part of ls_rsbtbl by testing on
+	 * RSB_HASHED flag.
+	 */
+	call_rcu(&r->rcu, __dlm_free_rsb);
+}
+
 struct dlm_lkb *dlm_allocate_lkb(struct dlm_ls *ls)
 {
 	struct dlm_lkb *lkb;
-- 
2.43.0

