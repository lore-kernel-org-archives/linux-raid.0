Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46948C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC25600D4
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhHBOqc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:46:32 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17036 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhHBOqT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 10:46:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627915562; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Zhie40wRbHP/Umbfbq615yGeoRV+ltuGL5EHcOd69V8LdvSDTVkFOUnsmtk3Y/pMLWmRtNx+zPUNCTkvfbx7Ez5fGBBf7GrVY7ee8HO8LRsX0NWbbxOgFIjDOvlYchNGYMEkPr8CB0Gcxr4uk+J59+7dUIrMv1zkZaEOIS/NpgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627915562; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=FMPBBp3ZliPmOT0LwGM+F/SjQeSLiL+5n8fzqIBgUf4=; 
        b=Rmo0QC7JAEdsi3fg3rLqcP8I9OOKlqihKIzSCBE78VMuzyh5ww/3cqbQaZQGzpGqQPy2CJK1j6ENGR2W7SyLUo88EsGYatcpRqqsaRS4XjzdS937rmQ7VirzCw9j4nc2qb5B1YmCm4BT+JEBPciaVDSQcpd8q84Hp4xCVqHAGuE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627915560170844.4754173667683; Mon, 2 Aug 2021 16:46:00 +0200 (CEST)
Subject: Re: [PATCH 2/5] tests: clear the superblock before adding a device to
 the array.
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     linux-raid@vger.kernel.org
References: <20210722182803.GA25122@oracle.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <e4fd4358-650f-f259-ca76-78a8342627d1@trained-monkey.org>
Date:   Mon, 2 Aug 2021 10:45:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210722182803.GA25122@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/22/21 2:28 PM, Sudhakar Panneerselvam wrote:
> This fixes '02lineargrow' test as prior metadata causes --add operation
> to fail.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  test | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/test b/test
> index 711a3c7a2076..39a85d77fa25 100755
> --- a/test
> +++ b/test
> @@ -48,7 +48,7 @@ mdadm() {
>  		;;
>  	esac
>  	case $* in
> -	*-C* | *--create* | *-B* | *--build* )
> +	*-C* | *--create* | *-B* | *--build* | *--add* )
>  		# clear superblock every time once creating or
>  		# building arrays, because it's always creating
>  		# and building array many times in a test case.
> @@ -59,7 +59,12 @@ mdadm() {
>  					$mdadm --zero $args > /dev/null
>  			}
>  		done
> -		$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
> +		if [[ $* == *--add* ]]
> +		then
> +			$mdadm 2> $targetdir/stderr --quiet "$@"
> +		else
> +			$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
> +		fi
>  		;;
>  	* )
>  		$mdadm 2> $targetdir/stderr --quiet "$@"
> 

I am not sure this is the right approach to fix this. --add has two
meanings and we would potentially want test cases where we make sure not
to add arrays with pre-existing meta-data on them. I think it's better
to fix this in 02lineargrow

Thanks,
Jes
