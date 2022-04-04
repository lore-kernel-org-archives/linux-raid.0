Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22697C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 13:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346907AbiDDN4t convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 09:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbiDDN4s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 09:56:48 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470AC3E5F5
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 06:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649080483; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=GP8h2QHtZHX8IEOOB0lrHg/3VWKcHVNuC8Dfo86KI077j7TNrn8LtAo3OOxz7N7u5eDntcTVF8uRbNI5UMDliJBzHve54V9z4h4dY4o1PQulepjhF1WlRFpBHqmliqxxxsGArAXCwqktSipFtbVaBDy7eq5xKPDUcHFSJ2d8GT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649080483; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8c3PAO0XRNdiluhsDWzxV2VVMQIYHWEIGdkYDC4PUVQ=; 
        b=Ls8uib40wfTpaJlPYPdmC4Bmu+wdP82cFrv8Ec1809yhVLTrnXSZ40CRvuYX7mKofGhVSMfu8imi8Qa9mVP4JeW6aNOnuxJ9GjNVTnBGnVOTtBjzpXSQ9ZT9g6KofBNEytvlPXIlahBQUhW+ZRVVF9OYS7MWTZnFDvYz+K1Etro=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649080482201158.24043970350408; Mon, 4 Apr 2022 15:54:42 +0200 (CEST)
Date:   Mon, 4 Apr 2022 09:54:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Monitor: use devname as char array instead of pointer
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220209085628.11418-1-kinga.tanska@intel.com>
 <ade5153b-d07a-9c26-5c8e-12b8356f61b4@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <517ddb46-2666-f616-ed56-6f046ef3824e@trained-monkey.org>
In-Reply-To: <ade5153b-d07a-9c26-5c8e-12b8356f61b4@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/19/22 11:42, Coly Li wrote:
> On 2/9/22 4:56 PM, Kinga Tanska wrote:
>> Device name wasn't filled properly due to incorrect use of strcpy.
> 
> Could you point out the specific location for improper strcpy?
> 
> 
>> Instead pointer, devname with fixed size is used and safer string
>> functions are propagated.
>>
>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
>> ---
>>   Monitor.c | 30 +++++++++++-------------------
>>   1 file changed, 11 insertions(+), 19 deletions(-)
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index 30c031a2..d02344ec 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -34,8 +34,8 @@
>>   #endif
>>     struct state {
>> -    char *devname;
>> -    char devnm[32];    /* to sync with mdstat info */
>> +    char devname[MD_NAME_MAX + 8];
>> +    char devnm[MD_NAME_MAX];    /* to sync with mdstat info */
>>       unsigned int utime;
>>       int err;
>>       char *spare_group;
>> @@ -46,7 +46,7 @@ struct state {
>>       int devstate[MAX_DISKS];
>>       dev_t devid[MAX_DISKS];
>>       int percent;
>> -    char parent_devnm[32]; /* For subarray, devnm of parent.
>> +    char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
>>                   * For others, ""
>>                   */
>>       struct supertype *metadata;
>> @@ -184,13 +184,7 @@ int Monitor(struct mddev_dev *devlist,
>>               if (strcasecmp(mdlist->devname, "<ignore>") == 0)
>>                   continue;
>>               st = xcalloc(1, sizeof *st);
>> -            if (mdlist->devname[0] == '/')
>> -                st->devname = xstrdup(mdlist->devname);
>> -            else {
>> -                st->devname = xmalloc(8+strlen(mdlist->devname)+1);
>> -                strcpy(strcpy(st->devname, "/dev/md/"),
>> -                       mdlist->devname);
>> -            }
>> +            snprintf(st->devname, MD_NAME_MAX + 8, "/dev/md/%s",
>> basename(mdlist->devname));
> 
> 
> I feel the above change is incorrect, the tailing '\0' of the string
> might be cut by your change.
> 
> 
>>               st->next = statelist;
>>               st->devnm[0] = 0;
>>               st->percent = RESYNC_UNKNOWN;
>> @@ -206,7 +200,7 @@ int Monitor(struct mddev_dev *devlist,
>>           for (dv = devlist; dv; dv = dv->next) {
>>               struct state *st = xcalloc(1, sizeof *st);
>>               mdlist = conf_get_ident(dv->devname);
>> -            st->devname = xstrdup(dv->devname);
>> +            snprintf(st->devname, MD_NAME_MAX + 8, "%s", dv->devname);
>>               st->next = statelist;
>>               st->devnm[0] = 0;
>>               st->percent = RESYNC_UNKNOWN;
>> @@ -289,7 +283,6 @@ int Monitor(struct mddev_dev *devlist,
>>           for (stp = &statelist; (st = *stp) != NULL; ) {
>>               if (st->from_auto && st->err > 5) {
>>                   *stp = st->next;
>> -                free(st->devname);
>>                   free(st->spare_group);
>>                   free(st);
>>               } else
>> @@ -540,7 +533,7 @@ static int check_array(struct state *st, struct
>> mdstat_ent *mdstat,
>>           goto disappeared;
>>         if (st->devnm[0] == 0)
>> -        strcpy(st->devnm, fd2devnm(fd));
>> +        snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
>>         for (mse2 = mdstat; mse2; mse2 = mse2->next)
>>           if (strcmp(mse2->devnm, st->devnm) == 0) {
>> @@ -670,7 +663,7 @@ static int check_array(struct state *st, struct
>> mdstat_ent *mdstat,
>>           strncmp(mse->metadata_version, "external:", 9) == 0 &&
>>           is_subarray(mse->metadata_version+9)) {
>>           char *sl;
>> -        strcpy(st->parent_devnm, mse->metadata_version + 10);
>> +        snprintf(st->parent_devnm, MD_NAME_MAX, "%s",
>> mse->metadata_version + 10);
>>           sl = strchr(st->parent_devnm, '/');
>>           if (sl)
>>               *sl = 0;
>> @@ -758,14 +751,13 @@ static int add_new_arrays(struct mdstat_ent
>> *mdstat, struct state **statelist,
>>                   continue;
>>               }
>>   -            st->devname = xstrdup(name);
>> +            snprintf(st->devname, MD_NAME_MAX + 8, "%s", name);
>>               if ((fd = open(st->devname, O_RDONLY)) < 0 ||
>>                   md_get_array_info(fd, &array) < 0) {
>>                   /* no such array */
>>                   if (fd >= 0)
>>                       close(fd);
>>                   put_md_name(st->devname);
>> -                free(st->devname);
>>                   if (st->metadata) {
>>                       st->metadata->ss->free_super(st->metadata);
>>                       free(st->metadata);
>> @@ -777,7 +769,7 @@ static int add_new_arrays(struct mdstat_ent
>> *mdstat, struct state **statelist,
>>               st->next = *statelist;
>>               st->err = 1;
>>               st->from_auto = 1;
>> -            strcpy(st->devnm, mse->devnm);
>> +            snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
>>               st->percent = RESYNC_UNKNOWN;
>>               st->expected_spares = -1;
>>               if (mse->metadata_version &&
>> @@ -785,8 +777,8 @@ static int add_new_arrays(struct mdstat_ent
>> *mdstat, struct state **statelist,
>>                       "external:", 9) == 0 &&
>>                   is_subarray(mse->metadata_version+9)) {
>>                   char *sl;
>> -                strcpy(st->parent_devnm,
>> -                    mse->metadata_version+10);
>> +                snprintf(st->parent_devnm, MD_NAME_MAX,
>> +                     "%s", mse->metadata_version + 10);
>>                   sl = strchr(st->parent_devnm, '/');
>>                   *sl = 0;
>>               } else
> 
> 
> With your change, the tailing '\0' for dev name might be cut. Could you
> please check whether it may introduce potential memleak ?

Kinga,

Any update on this?

Thanks,
Jes


