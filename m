Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E22C43334
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jul 2022 02:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbiGOCUl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jul 2022 22:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiGOCUk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jul 2022 22:20:40 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112F2A404
        for <linux-raid@vger.kernel.org>; Thu, 14 Jul 2022 19:20:38 -0700 (PDT)
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and ASSEMBLE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657851636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUjNC4xk0fdisuocemAfeXaYhLbln3+9Y2Z3PLn4sjw=;
        b=H2hWUF41PI1bb1SUgDZaKvlHzREKH2u2CHunNeqHJE+s9iD80uEafd2HtV0B1erd9hZI3E
        mL7MTuEBUyI0EKvqr8zErr2Ga0qCq/o5IB7iB0tJP8Dx4OUdEQhlsw1cHB2GqKG/Q8kVNF
        irG5Os5gsKxsRBsY1hOg/qS+NE5e3+A=
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220714223749.17250-1-logang@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
Date:   Fri, 15 Jul 2022 10:20:26 +0800
MIME-Version: 1.0
In-Reply-To: <20220714223749.17250-1-logang@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 7/15/22 6:37 AM, Logan Gunthorpe wrote:
> The mdadm command tries to open the md device for most modes, first
> thing, no matter what. When running to create or assemble an array,
> in most cases, the md device will not exist, the open call will fail
> and everything will proceed correctly.

I guess the BUILD mode doesn't need to create md as well since commit
7f91af49ad09 ("Delay creation of array devices for assemble/build/create").

> However, when running tests, a create or assembly command may be run
> shortly after stopping an array and the old md device file may still
> be around. Then, if create_on_open is set in the kernel, a new md
> device will be created when mdadm does its initial open.
>
> When mdadm gets around to creating the new device with the new_array
> parameter it issues this error:
>
>     mdadm: Fail to create md0 when using
>     /sys/module/md_mod/parameters/new_array, fallback to creation via node
>
> This is because an mddev was already created by the kernel with the
> earlier open() call and thus the new one being created will fail with
> EEXIST. The mdadm command will still successfully be created due to
> falling back to the node creation method. However, the error message
> itself will fail any test that's running it.
>
> This issue is a race condition that is very rare, but a recent change
> in the kernel caused this to happen more frequently: about 1 in 50
> times.
>
> To fix this, don't bother trying to open the md device for CREATE and
> ASSEMBLE commands, as the file descriptor will never be used anyway
> even if it is successfully openned.
>
> Side note: it would be nice to disable create_on_open as well to help
> solve this, but it seems the work for this was never finished. By default,
> mdadm will create using the old node interface when a name is specified
> unless the user specifically puts names=yes in a config file, which
> doesn't seem to be vcreate_on_openery common yet.

Hmm, 'create_on_open' is default to true, not sure if there is any side 
effect
after change to false.

> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   mdadm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mdadm.c b/mdadm.c
> index 56722ed997a2..3b886b5c0639 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1347,8 +1347,7 @@ int main(int argc, char *argv[])
>   	 * an md device.  We check that here and open it.
>   	 */
>   
> -	if (mode == MANAGE || mode == BUILD || mode == CREATE ||
> -	    mode == GROW || (mode == ASSEMBLE && ! c.scan)) {
> +	if (mode == MANAGE || mode == BUILD || mode == GROW) {
>   		if (devs_found < 1) {
>   			pr_err("an md device must be given in this mode\n");
>   			exit(2);

I think it is a reasonable change.

Thanks,
Guoqing
