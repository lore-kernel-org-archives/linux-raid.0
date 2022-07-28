Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A91C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiG1VIJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbiG1VIH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 17:08:07 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A123177A41
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 14:08:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659042480; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=E3agvOyC2uctd/VXeRUfqctkHUoQGkrdFki2rgXx1kVKhX9ErMhg/5PGIQW6kLDk5Y7RNpAVQrHVzhZrUpK/CgBiKmzJCKjzmqx5Jw1yioi0I59hIxiMXlTd6TCIPYUv28+lLBAXzu59UVcf7cMF1NfERw7uX3H2/EFjKJPCb5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1659042480; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WsmoihduGFToQGfyLjb7uT3pliB81cM/UfxxqTyviqM=; 
        b=KNX7uXDkJrxiKafVpjHwel4fQPkFveH+F3KkkRR/ggsmfjCFLce+9RUY1PQlux9uwcp1eDXHio821lT8fDNgbZF1liXREdgKQZCV/90KVkmmAzaxtcoPwDklfkofIkHTeyYPTV12DbfdyMtgizJJgHjDk6pJsl/h5/7WCDYx2ds=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 165904247928392.1990866659686; Thu, 28 Jul 2022 23:07:59 +0200 (CEST)
Date:   Thu, 28 Jul 2022 17:07:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] Monitor: use snprintf to fill device name
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220714070211.9941-1-kinga.tanska@intel.com>
 <20220714070211.9941-3-kinga.tanska@intel.com>
 <8C51EFAD-DF93-4724-A278-09B21D3BB567@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <216751bd-b4de-6517-da97-bbe6f295f39c@trained-monkey.org>
In-Reply-To: <8C51EFAD-DF93-4724-A278-09B21D3BB567@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/28/22 12:29, Coly Li wrote:
> 
> 
>> 2022年7月14日 15:02，Kinga Tanska <kinga.tanska@intel.com> 写道：
>>
>> Safe string functions are propagated in Monitor.c.
>>
>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> 
> 
> Personally I trends to avoid such change. The replacement for NAME by 32, is not only in Monitor.c, it can be found in other files, for example the following result by ‘grep -nr \\\[32\\\]’,
> 
> Grow.c:3692:	char last_devnm[32] = "";
> super-ddf.c:171:	__u8	header_ext[32];	/* reserved: fill with 0xff */
> super-ddf.c:356:	__u8	v0[32];	/* reserved- 0xff */
> super-ddf.c:357:	__u8	v1[32];	/* reserved- 0xff */
> super-ddf.c:360:	__u8	vendor[32];
> super-ddf.c:405:	__u8	vendor[32];
> sha1.h:84:  sha1_uint32 buffer[32];
> Manage.c:160:	char nm[32], *nmp;
> Manage.c:179:	char devnm[32];
> Manage.c:180:	char container[32];
> Manage.c:183:	char buf[32];
> Manage.c:982:		char devnm[32];
> Manage.c:1079:		char devnm[32];
> mdstat.c:157:		char devnm[32];
> lib.c:80:	static char devnm[32];
> lib.c:123:	static char devnm[32];
> util.c:1050:	char devname[32];
> util.c:1179:	char container[32] = "";
> sg_io.c:28:	unsigned char sense[32];
> Incremental.c:476:		char devnm[32];
> Incremental.c:1318:	char container[32];
> Incremental.c:1699:	char buf[32];
> Create.c:769:			char devnm[32];
> super-intel.c:537:	char devnm[32];
> super-intel.c:5250:	char nm[32];
> super-intel.c:11246:	static char devnm[32];
> super1.c:42:	char	set_name[32];	/* set and interpreted by user-space */
> super1.c:1139:	info->name[32] = 0;
> super1.c:1234:		info->name[32] = 0;
> mapfile.c:183:	char devnm[32];
> mdadm.h:357:	char		sys_name[32];
> mdadm.h:622:	char		devnm[32];
> mdadm.h:649:	char	devnm[32];
> mdadm.h:1239:	char container_devnm[32];    /* devnm of container */
> mdadm.h:1256:	char devnm[32]; /* e.g. md0.  This appears in metadata_version:
> Monitor.c:37:	char devnm[32];	/* to sync with mdstat info */
> Monitor.c:48:	char parent_devnm[32]; /* For subarray, devnm of parent.
> Monitor.c:1127:	char devnm[32];
> Monitor.c:1202:	char devnm[32];
> mdopen.c:176:	char devnm[32];
> mdopen.c:497:	static char devnm[32];
> 
> Many of them may related to the similar MD_NAME_MAX replace. Such replacement doesn’t fix real bug, but introduces many change to already working code. I don’t support such modification.
> 
> Maybe Jes has different opinion, this patch can be taken by him directly if he is fine with the change.

Hi Coly,

There is more to the patch than just replacing 32 with a #define. It
also replaces some unbounded strcpy() use which is definitely a good thing.

I am not a fan of having random numbered sizes like 32 across the code,
using an appropriate define makes it harder to mess up with a typo.

Getting rid of xstrdup() usage also seems to be a win in my book. The
behind the scenes malloc we have to track is easy to get wrong.

Cheers
Jes


> Thanks.
> 
> Coly Li
> 
> 
>> ---
>> Monitor.c | 37 ++++++++++++++-----------------------
>> 1 file changed, 14 insertions(+), 23 deletions(-)
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index a5b11ae2..93f36ac0 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -33,8 +33,8 @@
>> #endif
>>
>> struct state {
>> -	char *devname;
>> -	char devnm[32];	/* to sync with mdstat info */
>> +	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of "/dev/md/" + device name + terminating byte*/
>> +	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
>> 	unsigned int utime;
>> 	int err;
>> 	char *spare_group;
>> @@ -45,9 +45,9 @@ struct state {
>> 	int devstate[MAX_DISKS];
>> 	dev_t devid[MAX_DISKS];
>> 	int percent;
>> -	char parent_devnm[32]; /* For subarray, devnm of parent.
>> -				* For others, ""
>> -				*/
>> +	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
>> +					* For others, ""
>> +					*/
>> 	struct supertype *metadata;
>> 	struct state *subarray;/* for a container it is a link to first subarray
>> 				* for a subarray it is a link to next subarray
>> @@ -187,15 +187,8 @@ int Monitor(struct mddev_dev *devlist,
>> 				continue;
>>
>> 			st = xcalloc(1, sizeof *st);
>> -			if (mdlist->devname[0] == '/')
>> -				st->devname = xstrdup(mdlist->devname);
>> -			else {
>> -				/* length of "/dev/md/" + device name + terminating byte */
>> -				size_t _len = sizeof("/dev/md/") + strnlen(mdlist->devname, PATH_MAX);
>> -
>> -				st->devname = xcalloc(_len, sizeof(char));
>> -				snprintf(st->devname, _len, "/dev/md/%s", mdlist->devname);
>> -			}
>> +			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"),
>> +				 "/dev/md/%s", basename(mdlist->devname));
>> 			if (!is_mddev(mdlist->devname))
>> 				return 1;
>> 			st->next = statelist;
>> @@ -218,7 +211,7 @@ int Monitor(struct mddev_dev *devlist,
>>
>> 			st = xcalloc(1, sizeof *st);
>> 			mdlist = conf_get_ident(dv->devname);
>> -			st->devname = xstrdup(dv->devname);
>> +			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"), "%s", dv->devname);
>> 			st->next = statelist;
>> 			st->devnm[0] = 0;
>> 			st->percent = RESYNC_UNKNOWN;
>> @@ -301,7 +294,6 @@ int Monitor(struct mddev_dev *devlist,
>> 		for (stp = &statelist; (st = *stp) != NULL; ) {
>> 			if (st->from_auto && st->err > 5) {
>> 				*stp = st->next;
>> -				free(st->devname);
>> 				free(st->spare_group);
>> 				free(st);
>> 			} else
>> @@ -554,7 +546,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>> 		goto disappeared;
>>
>> 	if (st->devnm[0] == 0)
>> -		strcpy(st->devnm, fd2devnm(fd));
>> +		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
>>
>> 	for (mse2 = mdstat; mse2; mse2 = mse2->next)
>> 		if (strcmp(mse2->devnm, st->devnm) == 0) {
>> @@ -684,7 +676,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>> 	    strncmp(mse->metadata_version, "external:", 9) == 0 &&
>> 	    is_subarray(mse->metadata_version+9)) {
>> 		char *sl;
>> -		strcpy(st->parent_devnm, mse->metadata_version + 10);
>> +		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", mse->metadata_version + 10);
>> 		sl = strchr(st->parent_devnm, '/');
>> 		if (sl)
>> 			*sl = 0;
>> @@ -772,14 +764,13 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>> 				continue;
>> 			}
>>
>> -			st->devname = xstrdup(name);
>> +			snprintf(st->devname, MD_NAME_MAX + sizeof("/dev/md/"), "%s", name);
>> 			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
>> 			    md_get_array_info(fd, &array) < 0) {
>> 				/* no such array */
>> 				if (fd >= 0)
>> 					close(fd);
>> 				put_md_name(st->devname);
>> -				free(st->devname);
>> 				if (st->metadata) {
>> 					st->metadata->ss->free_super(st->metadata);
>> 					free(st->metadata);
>> @@ -791,7 +782,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>> 			st->next = *statelist;
>> 			st->err = 1;
>> 			st->from_auto = 1;
>> -			strcpy(st->devnm, mse->devnm);
>> +			snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
>> 			st->percent = RESYNC_UNKNOWN;
>> 			st->expected_spares = -1;
>> 			if (mse->metadata_version &&
>> @@ -799,8 +790,8 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>> 				    "external:", 9) == 0 &&
>> 			    is_subarray(mse->metadata_version+9)) {
>> 				char *sl;
>> -				strcpy(st->parent_devnm,
>> -					mse->metadata_version+10);
>> +				snprintf(st->parent_devnm, MD_NAME_MAX,
>> +					 "%s", mse->metadata_version + 10);
>> 				sl = strchr(st->parent_devnm, '/');
>> 				*sl = 0;
>> 			} else
>> -- 
>> 2.26.2
>>
> 


