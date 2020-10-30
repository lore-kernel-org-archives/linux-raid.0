Return-Path: <SRS0=hsaE=EF=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675DCC56201
	for <linux-raid@archiver.kernel.org>; Fri, 30 Oct 2020 05:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E932620723
	for <linux-raid@archiver.kernel.org>; Fri, 30 Oct 2020 05:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gfur+lhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgJ3Fxt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:53:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgJ3Fxt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Oct 2020 01:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604037227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hn2IzAOwiraZM76dwJfMK7GGyzOOVI/se7VYHK9Ap98=;
        b=Gfur+lhFt3tMqOiBzae1rT3U+RzpGblxFPd3b7viH0csewaEdlffSbdAApINMSogXOT3or
        fBXorg0yOr0gfsOt1YH6spTKMPkxdOQHMtaE9CmIdwXiEUIfJhyz2jgPKHni3gNRueYE0C
        TGDXVYKO9b2CL+eaJ9JfpdgEQj/TLW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-2EKgt1MZO0q2OKi5sQ4sBA-1; Fri, 30 Oct 2020 01:53:43 -0400
X-MC-Unique: 2EKgt1MZO0q2OKi5sQ4sBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A54F1868403;
        Fri, 30 Oct 2020 05:53:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-36.pek2.redhat.com [10.72.8.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C87515578C;
        Fri, 30 Oct 2020 05:53:39 +0000 (UTC)
Subject: Re: [PATCH 1/1] mdadm/bitmap: locate bitmap calcuate bitmap position
 wrongly
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        jes@trained-monkey.org
Cc:     ncroxon@redhat.com, heinzm@redhat.com, linux-raid@vger.kernel.org
References: <1603865064-27404-1-git-send-email-xni@redhat.com>
 <95046dfe-c770-8950-c720-6b1d30bb1789@suse.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <f0616f2c-7156-8717-349d-7dcf349fd421@redhat.com>
Date:   Fri, 30 Oct 2020 13:53:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <95046dfe-c770-8950-c720-6b1d30bb1789@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Heming

The cluster raid is only supported by super 1.2, so we don't need to 
consider the old system when
it's a cluster raid.

Regards
Xiao

On 10/28/2020 08:29 PM, heming.zhao@suse.com wrote:
> Hello Xiao,
>
> My review comment:
> You code only work in modern system. the boundary is 4k not 512, because using hardcode 4k to call calc_bitmap_size
>
> In current cluster env, if bitmap area beyond 4K size (or 512 in very old system), locate_bitmap1
> will return wrong address.
>
> Please refer write_bitmap1() to saparate 512 & 4096 case.
>
> On 10/28/20 2:04 PM, Xiao Ni wrote:
>> Now it only adds bitmap offset based on cluster nodes. It's not right. It needs to
>> add per node bitmap space to find next node bitmap position.
>>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>    super1.c | 12 +++++++++---
>>    1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 8b0d6ff..b5b379b 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -2582,8 +2582,9 @@ add_internal_bitmap1(struct supertype *st,
>>    
>>    static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>>    {
>> -	unsigned long long offset;
>> +	unsigned long long offset, bm_sectors_per_node;
>>    	struct mdp_superblock_1 *sb;
>> +	bitmap_super_t *bms;
>>    	int mustfree = 0;
>>    	int ret;
>>    
>> @@ -2598,8 +2599,13 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>>    		ret = 0;
>>    	else
>>    		ret = -1;
>> -	offset = __le64_to_cpu(sb->super_offset);
>> -	offset += (int32_t) __le32_to_cpu(sb->bitmap_offset) * (node_num + 1);
>> +
>> +	offset = __le64_to_cpu(sb->super_offset) + __le32_to_cpu(sb->bitmap_offset);
>> +	if (node_num) {
>> +		bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
>> +		bm_sectors_per_node = calc_bitmap_size(bms, 4096) >> 9;
>> +		offset += bm_sectors_per_node * node_num;
>> +	}
>>    	if (mustfree)
>>    		free(sb);
>>    	lseek64(fd, offset<<9, 0);
>>

