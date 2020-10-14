Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52479C433E7
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A142222A
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgJNPiS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:38:18 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17312 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgJNPiS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:38:18 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602688981; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=UF8mLYFTQLaiQtEPv1CQRKr2gMFAhQPNddOiE9lCPGDFqOkVBMb+1hPn+GMTAIZey65dYHHylJgZnDiG6FbK48IhdV+Pla1WEV9YLraiGux+O7K37QhLWiQ8eJPzh8QcEFFeU7EPL9jtsvXp/exNRrge55q5PNo2eEmNPBna1iU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602688981; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gyR1wAiUtztq6yro3XqFMYFxM5uP4SOLQ6KV2BuxaKc=; 
        b=Gn+xfeZVewz0/9bFhvlaz357Brk3MZNQlNkv/1uFX0UnBv2XT3mrdm0VTCxsN72yyLTCbdwlWT5LGH8tM4YYoFHqOu727rC73vqH02dKsMoxf5nMbH9WXjgf+upmrq/k9XHqOfYYT7SVdfn4DvJCcEcRndaQ8m5mT0PRyxxQ+3s=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602688979667554.4778839187269; Wed, 14 Oct 2020 17:22:59 +0200 (CEST)
Subject: Re: [PATCH V2 1/2] Check hostname file empty or not when creating
 raid device
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com, antmbox@youngman.org.uk
References: <1600155882-4488-1-git-send-email-xni@redhat.com>
 <1600155882-4488-2-git-send-email-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <26eb6bfd-b7f5-6415-86bf-d6f2d39dda73@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:22:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600155882-4488-2-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/15/20 3:44 AM, Xiao Ni wrote:
> If /etc/hostname is empty and the hostname is decided by network(dhcp, e.g.), there is a
> risk that raid device will not be in active state after boot. It will be auto-read-only
> state. It depends on the boot sequence. If the storage starts before network. The system
> detects disks first, udev rules are triggered and raid device is assemble automatically.
> But the network hasn't started successfully. So mdadm can't get the right hostname. The
> raid device will be treated as a foreign raid.
> Add a note message if /etc/hostname is empty when creating a raid device.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  mdadm.c |  3 +++
>  mdadm.h |  1 +
>  util.c  | 19 +++++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/mdadm.c b/mdadm.c
> index 1b3467f..e551958 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1408,6 +1408,9 @@ int main(int argc, char *argv[])
>  	if (c.homehost == NULL && c.require_homehost)
>  		c.homehost = conf_get_homehost(&c.require_homehost);
>  	if (c.homehost == NULL || strcasecmp(c.homehost, "<system>") == 0) {
> +		if (check_hostname())
> +			pr_err("Note: The file /etc/hostname is empty. There is a risk the raid\n"
> +				"      can't be active after boot\n");
>  		if (gethostname(sys_hostname, sizeof(sys_hostname)) == 0) {
>  			sys_hostname[sizeof(sys_hostname)-1] = 0;
>  			c.homehost = sys_hostname;
> diff --git a/mdadm.h b/mdadm.h
> index 399478b..3ef1209 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1480,6 +1480,7 @@ extern int parse_cluster_confirm_arg(char *inp, char **devname, int *slot);
>  extern int check_ext2(int fd, char *name);
>  extern int check_reiser(int fd, char *name);
>  extern int check_raid(int fd, char *name);
> +extern int check_hostname(void);
>  extern int check_partitions(int fd, char *dname,
>  			    unsigned long long freesize,
>  			    unsigned long long size);
> diff --git a/util.c b/util.c
> index 579dd42..de5bad0 100644
> --- a/util.c
> +++ b/util.c
> @@ -694,6 +694,25 @@ int check_raid(int fd, char *name)
>  	return 1;
>  }
>  
> +/* It checks /etc/hostname has value or not */
> +int check_hostname()
> +{
> +	int fd, ret = 0;
> +	char buf[256];
> +
> +	fd = open("/etc/hostname", O_RDONLY);
> +	if (fd < 0) {
> +		ret = 1;
> +		goto out;
> +	}

I don't think this is the right approach. If someone uses dhcp to obtain
the hostname and explicitly configured the raid to start after the
network, they shouldn't get nagged by this message.

Any reason you cannot use gethostname(2) for this?

Thanks,
Jes

