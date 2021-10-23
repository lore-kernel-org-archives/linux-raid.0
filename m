Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D12C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 23 Oct 2021 21:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0683560F46
	for <linux-raid@archiver.kernel.org>; Sat, 23 Oct 2021 21:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhJWVQN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Oct 2021 17:16:13 -0400
Received: from outbound5d.eu.mailhop.org ([3.121.156.226]:25074 "EHLO
        outbound5d.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhJWVQN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Oct 2021 17:16:13 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Oct 2021 17:16:13 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1635022671; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=R+gXz/gSNL0R1ErO6WgqLP5YGTtyzmzNZyxN1WDGlunWN+QS7ejAsAhmyBuADrnTbr9rMKdJZXyXa
         vOh0YEyoZaz7g8ioq4d+tlFp/u5CII0RZvwTlTB8wj1hRlrN65ZR1Xyk8SvutQQiV/UpQ0VDoH3JVo
         p52vmIEfvkbtBnKDWry6ZY78VIw8IOPrBcScl1kMRUaRjJAtPfG83UBnuBHh2LVpb1DxbLQcM8o0pt
         rvE9AQf/02zpWhMYngbl6398Iq4vgElRDNQTc5iI4SDCJhbgyzkl1lwtds60zdFJbYZlf7TZenO9ne
         N4kKC8n2uCgx3bNHXW/g5tA38DfEyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:dkim-signature:from;
        bh=aAoNuUcelwAZWiiEEFjNPDIHGUACSvg5ESpChEx5jtk=;
        b=A7pzVP7ioH4b1/0C15zVUygvKgn/gxhN5GnX8aBp9S7vIh+/V9jg3YLiF7jHdEnl+ANUI7H1zpotE
         6kMneT1NtA6YcJXoYYeFcLVevGGX1bisoQX4HzR5uAbPSWt1DgEZCm84IVkEPaq+h4+xjOgz4TMrCh
         hdJcxNkIF/ARUPX9Wj0EG5RQortddJ8Ki9qM2UasspapiASSs7pvShGxsn7dw4PQZ35uVN9AhF9pQf
         JkWRwKA6vKaqcWDhgcXfAgEXfgwTUpihn2CrNDHGi5MdKC1Uyfel1yyl6D+D+za6TEAArg3/RoDFXM
         /UDiOj2EVn5DVeJRQWQr0TFE7BeYr1g==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=none smtp.mailfrom=cas.homelinux.org smtp.remote-ip=72.83.183.41;
        dmarc=none header.from=cas.homelinux.org;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:from;
        bh=aAoNuUcelwAZWiiEEFjNPDIHGUACSvg5ESpChEx5jtk=;
        b=dBoAqo4lK01J5eABoz3bMu33mFz2tNNCLiUfWYdHdSZ+XYIXrnU6x5qKJy/dDACcV6pl5wbq+dWGi
         IO5t2Gvt+f2Wzc1ClvsaJYMFyxBposdWKaZ4Amk6rBIWma9I+Uk2EwImwGiIqAsmK9QBM4LFOfp79m
         S0W1scD/cHXyknuV/Jgz0Q2aWmJwl4Yd1OizSPOsVHDM2JK2swKTCUANAc2Jxyib00J0CuqrtTgA3l
         +fXqSNjaZIoG/zmXci44VoxngfUSAU8kgdIGnwWHb5HEl4a/8fHMWECrsP1H4pSJZstgK+gWBb3ixI
         0yDjZ2RW52VayU8BxKp1dRPgWU+9Atw==
X-Originating-IP: 72.83.183.41
X-MHO-RoutePath: Y3NjaGFuemxl
X-MHO-User: e0e3e93f-3443-11ec-a40e-d17a12b91375
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from [192.168.4.59] (pool-72-83-183-41.washdc.fios.verizon.net [72.83.183.41])
        by outbound3.eu.mailhop.org (Halon) with ESMTPSA
        id e0e3e93f-3443-11ec-a40e-d17a12b91375;
        Sat, 23 Oct 2021 20:57:49 +0000 (UTC)
Message-ID: <e9bbc66b-38e5-e7c7-26b8-cb17cf73e7e6@cas.homelinux.org>
Date:   Sat, 23 Oct 2021 16:57:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Inconsistent device numbers after reboot
Content-Language: en-US
To:     list Linux RAID <linux-raid@vger.kernel.org>
References: <d2daf328-69ab-c540-aaf3-97e4a6ea4355@cas.homelinux.org>
 <24948.24578.330988.759209@cyme.ty.sabi.co.uk>
From:   Chris Schanzle <schanzle@cas.homelinux.org>
In-Reply-To: <24948.24578.330988.759209@cyme.ty.sabi.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/23/21 15:18, Peter Grandi wrote:
>> The device ID of my partition containing my home directory
>> changes (sometimes) when I reboot
> This is an intrinsic behaviour of the Linux kernel, and it is
> futile to fight it
>
>> Changing device ID's causes havoc with tar incremental backups
>> - tar consider all files are new.
> For that reason there is a specific option in recent versions of
> GNU 'tar':
>
>         "--no-check-device
>                Do not check device numbers when creating incremental archives."

Excellent, was not aware of that option. Thank you!

