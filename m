Return-Path: <SRS0=bg3X=DW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BCFC433E7
	for <linux-raid@archiver.kernel.org>; Thu, 15 Oct 2020 13:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2346206FB
	for <linux-raid@archiver.kernel.org>; Thu, 15 Oct 2020 13:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JiE9+7bs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbgJONkj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Oct 2020 09:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729837AbgJONke (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 15 Oct 2020 09:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602769232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhiXFvq5/eE1MBb5AYs7ODz+9T4aREKNTq3do+Hv56I=;
        b=JiE9+7bsZlUkTwIWIeHMwJ2Frq1+SexnN0DrQRNZCd1fhYKKzBHmkyTJEQUzMstfEeLDJG
        lQxpU/DJr2dImTYTcED75rlXoadJCV5Ep+7/DZ0WPkfedEp/n+gbiyKtnsnduSc11WkZPj
        kEg2KOJQ6ImG42n5KECBUtvaqxMau1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-09HXcPGXOlCQWzSY6yrPiQ-1; Thu, 15 Oct 2020 09:40:31 -0400
X-MC-Unique: 09HXcPGXOlCQWzSY6yrPiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2BC58015A3;
        Thu, 15 Oct 2020 13:40:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2328C1000232;
        Thu, 15 Oct 2020 13:40:26 +0000 (UTC)
Subject: Re: [PATCH V2 1/2] Check hostname file empty or not when creating
 raid device
To:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com, antmbox@youngman.org.uk
References: <1600155882-4488-1-git-send-email-xni@redhat.com>
 <1600155882-4488-2-git-send-email-xni@redhat.com>
 <26eb6bfd-b7f5-6415-86bf-d6f2d39dda73@trained-monkey.org>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <bd3b051a-6455-49f9-9545-e1caff3027ac@redhat.com>
Date:   Thu, 15 Oct 2020 21:40:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <26eb6bfd-b7f5-6415-86bf-d6f2d39dda73@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/14/2020 11:22 PM, Jes Sorensen wrote:
> On 9/15/20 3:44 AM, Xiao Ni wrote:
>> If /etc/hostname is empty and the hostname is decided by network(dhcp, e.g.), there is a
>> risk that raid device will not be in active state after boot. It will be auto-read-only
>> state. It depends on the boot sequence. If the storage starts before network. The system
>> detects disks first, udev rules are triggered and raid device is assemble automatically.
>> But the network hasn't started successfully. So mdadm can't get the right hostname. The
>> raid device will be treated as a foreign raid.
>> Add a note message if /etc/hostname is empty when creating a raid device.
>>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>   mdadm.c |  3 +++
>>   mdadm.h |  1 +
>>   util.c  | 19 +++++++++++++++++++
>>   3 files changed, 23 insertions(+)
>>
>> diff --git a/mdadm.c b/mdadm.c
>> index 1b3467f..e551958 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -1408,6 +1408,9 @@ int main(int argc, char *argv[])
>>   	if (c.homehost == NULL && c.require_homehost)
>>   		c.homehost = conf_get_homehost(&c.require_homehost);
>>   	if (c.homehost == NULL || strcasecmp(c.homehost, "<system>") == 0) {
>> +		if (check_hostname())
>> +			pr_err("Note: The file /etc/hostname is empty. There is a risk the raid\n"
>> +				"      can't be active after boot\n");
>>   		if (gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
>>   			sys_hostname[sizeof(sys_hostname)-1] = 0;
>>   			c.homehost = sys_hostname;
>> diff --git a/mdadm.h b/mdadm.h
>> index 399478b..3ef1209 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -1480,6 +1480,7 @@ extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
>>   extern int check_ext2(int fd, char *name);
>>   extern int check_reiser(int fd, char *name);
>>   extern int check_raid(int fd, char *name);
>> +extern int check_hostname(void);
>>   extern int check_partitions(int fd, char *dname,
>>   			    unsigned long long freesize,
>>   			    unsigned long long size);
>> diff --git a/util.c b/util.c
>> index 579dd42..de5bad0 100644
>> --- a/util.c
>> +++ b/util.c
>> @@ -694,6 +694,25 @@ int check_raid(int fd, char *name)
>>   	return 1;
>>   }
>>   
>> +/* It checks /etc/hostname has value or not */
>> +int check_hostname()
>> +{
>> +	int fd, ret = 0;
>> +	char buf[256];
>> +
>> +	fd = open("/etc/hostname", O_RDONLY);
>> +	if (fd < 0) {
>> +		ret = 1;
>> +		goto out;
>> +	}
> I don't think this is the right approach. If someone uses dhcp to obtain
> the hostname and explicitly configured the raid to start after the
> network, they shouldn't get nagged by this message.
>
> Any reason you cannot use gethostname(2) for this?
Hi Jes

If the raid device is used as root device and the network service needs some
files that on the raid device, so the raid device need to be assemble 
first. The
system call gethostname can't return the right hostname in this case.

But the patch has some problem. If the /etc/mdadm.conf has the raid 
information already,
it can assemble the raid successfully without considering hostname. I'll 
try to send another patch.

Regards
Xiao

