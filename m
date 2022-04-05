Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B68C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 14:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiDEPAt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 11:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354694AbiDENRa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 09:17:30 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94AB130C12
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 05:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649161321; x=1680697321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZnOstJtjyZAyi15BWyku+vhYPAFYrmphCVjkgoGFz6U=;
  b=RQZ0OUM+DZ1DGQy1cWQZx3VF/apoTJvJTO/4yl0VAUpV7OPfUDRBDwYs
   h27acV2dODY14OMBV4S4mn+oJtBUgAU46fJDNySZ/ZT5ge6oYy4H9+1n+
   Z6wpnfhVuH0Y6koZ/JsiSP/6QAluzMN2lyGBNwVm6rFT0/DZat9A0hD6v
   q8zVqZ/76b43Mz7RD4gf7M1hV3TjQ+D8qnuIMabf1KRF3HjRNTrFvnwnG
   Nzuac7cqBiage9fcxV3patqy1L3k0haUVFNYq0H7cNdcveLv+zWVo3zLL
   xBhZNo/TCkQBnoinCzIYFzOwEX3tYTgHgOP5fUuuvchcIrlWp03agcv4b
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="321429806"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321429806"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 05:22:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="549034745"
Received: from ktanska-mobl.ger.corp.intel.com (HELO [10.252.43.42]) ([10.252.43.42])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 05:21:59 -0700
Message-ID: <1f34cd39-c9ee-ee48-6133-67f5abf3e9b1@linux.intel.com>
Date:   Tue, 5 Apr 2022 14:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Monitor: use devname as char array instead of pointer
To:     Jes Sorensen <jes@trained-monkey.org>, Coly Li <colyli@suse.de>,
        Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220209085628.11418-1-kinga.tanska@intel.com>
 <ade5153b-d07a-9c26-5c8e-12b8356f61b4@suse.de>
 <517ddb46-2666-f616-ed56-6f046ef3824e@trained-monkey.org>
From:   "Tanska, Kinga" <kinga.tanska@linux.intel.com>
In-Reply-To: <517ddb46-2666-f616-ed56-6f046ef3824e@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I will send correction in next patchset. I didn't include terminating null
byte '\0' to size in snprintf function, which can cause memleaks.
Also specific location of incorrect usage of strcpy will be pointed out 
in commit message.

Regards,
Kinga

On 4/4/2022 3:54 PM, Jes Sorensen wrote:

On 3/19/22 11:42, Coly Li wrote:

> On 2/9/22 4:56 PM, Kinga Tanska wrote:
>> Device name wasn't filled properly due to incorrect use of strcpy.
> Could you point out the specific location for improper strcpy?
>
>
>> Instead pointer, devname with fixed size is used and safer string
>> functions are propagated.
>>
>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
>> ---
>>    Monitor.c | 30 +++++++++++-------------------
>>    1 file changed, 11 insertions(+), 19 deletions(-)
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index 30c031a2..d02344ec 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -34,8 +34,8 @@
>>    #endif
>>      struct state {
>> -    char *devname;
>> -    char devnm[32];    /* to sync with mdstat info */
>> +    char devname[MD_NAME_MAX + 8];
>> +    char devnm[MD_NAME_MAX];    /* to sync with mdstat info */
>>        unsigned int utime;
>>        int err;
>>        char *spare_group;
>> @@ -46,7 +46,7 @@ struct state {
>>        int devstate[MAX_DISKS];
>>        dev_t devid[MAX_DISKS];
>>        int percent;
>> -    char parent_devnm[32]; /* For subarray, devnm of parent.
>> +    char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of parent.
>>                    * For others, ""
>>                    */
>>        struct supertype *metadata;
>> @@ -184,13 +184,7 @@ int Monitor(struct mddev_dev *devlist,
>>                if (strcasecmp(mdlist->devname, "<ignore>") == 0)
>>                    continue;
>>                st = xcalloc(1, sizeof *st);
>> -            if (mdlist->devname[0] == '/')
>> -                st->devname = xstrdup(mdlist->devname);
>> -            else {
>> -                st->devname = xmalloc(8+strlen(mdlist->devname)+1);
>> -                strcpy(strcpy(st->devname, "/dev/md/"),
>> -                       mdlist->devname);
>> -            }
>> +            snprintf(st->devname, MD_NAME_MAX + 8, "/dev/md/%s",
>> basename(mdlist->devname));
> I feel the above change is incorrect, the tailing '\0' of the string
> might be cut by your change.
>
>
>>                st->next = statelist;
>>                st->devnm[0] = 0;
>>                st->percent = RESYNC_UNKNOWN;
>> @@ -206,7 +200,7 @@ int Monitor(struct mddev_dev *devlist,
>>            for (dv = devlist; dv; dv = dv->next) {
>>                struct state *st = xcalloc(1, sizeof *st);
>>                mdlist = conf_get_ident(dv->devname);
>> -            st->devname = xstrdup(dv->devname);
>> +            snprintf(st->devname, MD_NAME_MAX + 8, "%s", dv->devname);
>>                st->next = statelist;
>>                st->devnm[0] = 0;
>>                st->percent = RESYNC_UNKNOWN;
>> @@ -289,7 +283,6 @@ int Monitor(struct mddev_dev *devlist,
>>            for (stp = &statelist; (st = *stp) != NULL; ) {
>>                if (st->from_auto && st->err > 5) {
>>                    *stp = st->next;
>> -                free(st->devname);
>>                    free(st->spare_group);
>>                    free(st);
>>                } else
>> @@ -540,7 +533,7 @@ static int check_array(struct state *st, struct
>> mdstat_ent *mdstat,
>>            goto disappeared;
>>          if (st->devnm[0] == 0)
>> -        strcpy(st->devnm, fd2devnm(fd));
>> +        snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
>>          for (mse2 = mdstat; mse2; mse2 = mse2->next)
>>            if (strcmp(mse2->devnm, st->devnm) == 0) {
>> @@ -670,7 +663,7 @@ static int check_array(struct state *st, struct
>> mdstat_ent *mdstat,
>>            strncmp(mse->metadata_version, "external:", 9) == 0 &&
>>            is_subarray(mse->metadata_version+9)) {
>>            char *sl;
>> -        strcpy(st->parent_devnm, mse->metadata_version + 10);
>> +        snprintf(st->parent_devnm, MD_NAME_MAX, "%s",
>> mse->metadata_version + 10);
>>            sl = strchr(st->parent_devnm, '/');
>>            if (sl)
>>                *sl = 0;
>> @@ -758,14 +751,13 @@ static int add_new_arrays(struct mdstat_ent
>> *mdstat, struct state **statelist,
>>                    continue;
>>                }
>>    -            st->devname = xstrdup(name);
>> +            snprintf(st->devname, MD_NAME_MAX + 8, "%s", name);
>>                if ((fd = open(st->devname, O_RDONLY)) < 0 ||
>>                    md_get_array_info(fd, &array) < 0) {
>>                    /* no such array */
>>                    if (fd >= 0)
>>                        close(fd);
>>                    put_md_name(st->devname);
>> -                free(st->devname);
>>                    if (st->metadata) {
>>                        st->metadata->ss->free_super(st->metadata);
>>                        free(st->metadata);
>> @@ -777,7 +769,7 @@ static int add_new_arrays(struct mdstat_ent
>> *mdstat, struct state **statelist,
>>                st->next = *statelist;
>>                st->err = 1;
>>                st->from_auto = 1;
>> -            strcpy(st->devnm, mse->devnm);
>> +            snprintf(st->devnm, MD_NAME_MAX, "%s", mse->devnm);
>>                st->percent = RESYNC_UNKNOWN;
>>                st->expected_spares = -1;
>>                if (mse->metadata_version &&
>> @@ -785,8 +777,8 @@ static int add_new_arrays(struct mdstat_ent
>> *mdstat, struct state **statelist,
>>                        "external:", 9) == 0 &&
>>                    is_subarray(mse->metadata_version+9)) {
>>                    char *sl;
>> -                strcpy(st->parent_devnm,
>> -                    mse->metadata_version+10);
>> +                snprintf(st->parent_devnm, MD_NAME_MAX,
>> +                     "%s", mse->metadata_version + 10);
>>                    sl = strchr(st->parent_devnm, '/');
>>                    *sl = 0;
>>                } else
> With your change, the tailing '\0' for dev name might be cut. Could you
> please check whether it may introduce potential memleak ?

Kinga,

Any update on this?

Thanks,
Jes


