Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4A5C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 15:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbiCSPoY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243529AbiCSPoW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 11:44:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCB1DE89
        for <linux-raid@vger.kernel.org>; Sat, 19 Mar 2022 08:42:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5E9F021106;
        Sat, 19 Mar 2022 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647704578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BVBuz9Q3KIuTQekH/xhq+FySBduxABtbT3QM2Wrvzg=;
        b=YSnbg5ZwFPu1uowlAQPPOT7PL5oX6neCIU5jLA04Xwibxpas0ZdRcHoeCscjnuLNRJEA8N
        FaGm0v5DCYhARSboYV3CwYp2U3LyznIvdXn4ZM1QLNia3oSGwpc1WDWnlnOahblfqsgCkl
        QF+mJ3CXImJk+D+ZmLe2pviZYJ/pzhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647704578;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BVBuz9Q3KIuTQekH/xhq+FySBduxABtbT3QM2Wrvzg=;
        b=kTS/7fc1uyvO63owZknDWS6XR7YDGuge2FiTpmmfd3C+iKvBbbvyBn8a/qFM0251vBQtyY
        nUnpV3MsbbmbG2Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE29A132C1;
        Sat, 19 Mar 2022 15:42:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nvGUHAD6NWKLEgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 19 Mar 2022 15:42:56 +0000
Message-ID: <ade5153b-d07a-9c26-5c8e-12b8356f61b4@suse.de>
Date:   Sat, 19 Mar 2022 23:42:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] Monitor: use devname as char array instead of pointer
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220209085628.11418-1-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220209085628.11418-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/9/22 4:56 PM, Kinga Tanska wrote:
> Device name wasn't filled properly due to incorrect use of strcpy.

Could you point out the specific location for improper strcpy?


> Instead pointer, devname with fixed size is used and safer string
> functions are propagated.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>   Monitor.c | 30 +++++++++++-------------------
>   1 file changed, 11 insertions(+), 19 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 30c031a2..d02344ec 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -34,8 +34,8 @@
>   #endif
>   
>   struct state {
> -	char *devname;
> -	char devnm[32];	/* to sync with mdstat info */
> +	char devname[MD_NAME_MAX + 8];
> +	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
>   	unsigned int utime;
>   	int err;
>   	char *spare_group;
> @@ -46,7 +46,7 @@ struct state {
>   	int devstate[MAX_DISKS];
>   	dev_t devid[MAX_DISKS];
>   	int percent;
> -	char parent_devnm[32]; /* For subarray, devnm of parent.
> +	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
>   				* For others, ""
>   				*/
>   	struct supertype *metadata;
> @@ -184,13 +184,7 @@ int Monitor(struct mddev_dev *devlist,
>   			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
>   				continue;
>   			st = xcalloc(1, sizeof *st);
> -			if (mdlist->devname[0] == '/')
> -				st->devname = xstrdup(mdlist->devname);
> -			else {
> -				st->devname = xmalloc(8+strlen(mdlist->devname)+1);
> -				strcpy(strcpy(st->devname, "/dev/md/"),
> -				       mdlist->devname);
> -			}
> +			snprintf(st->devname, MD_NAME_MAX + 8, "/dev/md/%s", basename(mdlist->devname));


I feel the above change is incorrect, the tailing '\0' of the string 
might be cut by your change.


>   			st->next = statelist;
>   			st->devnm[0] = 0;
>   			st->percent = RESYNC_UNKNOWN;
> @@ -206,7 +200,7 @@ int Monitor(struct mddev_dev *devlist,
>   		for (dv = devlist; dv; dv = dv->next) {
>   			struct state *st = xcalloc(1, sizeof *st);
>   			mdlist = conf_get_ident(dv->devname);
> -			st->devname = xstrdup(dv->devname);
> +			snprintf(st->devname, MD_NAME_MAX + 8, "%s", dv->devname);
>   			st->next = statelist;
>   			st->devnm[0] = 0;
>   			st->percent = RESYNC_UNKNOWN;
> @@ -289,7 +283,6 @@ int Monitor(struct mddev_dev *devlist,
>   		for (stp = &statelist; (st = *stp) != NULL; ) {
>   			if (st->from_auto && st->err > 5) {
>   				*stp = st->next;
> -				free(st->devname);
>   				free(st->spare_group);
>   				free(st);
>   			} else
> @@ -540,7 +533,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   		goto disappeared;
>   
>   	if (st->devnm[0] == 0)
> -		strcpy(st->devnm, fd2devnm(fd));
> +		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
>   
>   	for (mse2 = mdstat; mse2; mse2 = mse2->next)
>   		if (strcmp(mse2->devnm, st->devnm) == 0) {
> @@ -670,7 +663,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
>   	    is_subarray(mse->metadata_version+9)) {
>   		char *sl;
> -		strcpy(st->parent_devnm, mse->metadata_version + 10);
> +		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", mse->metadata_version + 10);
>   		sl = strchr(st->parent_devnm, '/');
>   		if (sl)
>   			*sl = 0;
> @@ -758,14 +751,13 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>   				continue;
>   			}
>   
> -			st->devname = xstrdup(name);
> +			snprintf(st->devname, MD_NAME_MAX + 8, "%s", name);
>   			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
>   			    md_get_array_info(fd, &array) < 0) {
>   				/* no such array */
>   				if (fd >= 0)
>   					close(fd);
>   				put_md_name(st->devname);
> -				free(st->devname);
>   				if (st->metadata) {
>   					st->metadata->ss->free_super(st->metadata);
>   					free(st->metadata);
> @@ -777,7 +769,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>   			st->next = *statelist;
>   			st->err = 1;
>   			st->from_auto = 1;
> -			strcpy(st->devnm, mse->devnm);
> +			snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
>   			st->percent = RESYNC_UNKNOWN;
>   			st->expected_spares = -1;
>   			if (mse->metadata_version &&
> @@ -785,8 +777,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>   				    "external:", 9) == 0 &&
>   			    is_subarray(mse->metadata_version+9)) {
>   				char *sl;
> -				strcpy(st->parent_devnm,
> -					mse->metadata_version+10);
> +				snprintf(st->parent_devnm, MD_NAME_MAX,
> +					 "%s", mse->metadata_version + 10);
>   				sl = strchr(st->parent_devnm, '/');
>   				*sl = 0;
>   			} else


With your change, the tailing '\0' for dev name might be cut. Could you 
please check whether it may introduce potential memleak ?


Thanks.


Coly Li


