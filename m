Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A520CC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 06:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349674AbiELG2e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 02:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350345AbiELG2L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 02:28:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921966D857;
        Wed, 11 May 2022 23:27:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 432EA68BEB; Thu, 12 May 2022 08:27:28 +0200 (CEST)
Date:   Thu, 12 May 2022 08:27:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Christoph Hellwig <hch@lst.de>, song@kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] md: remove most calls to bdevname
Message-ID: <20220512062727.GA20557@lst.de>
References: <20220512061913.1826735-1-hch@lst.de> <290eada6-226a-6570-1860-c4ca1d680993@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <290eada6-226a-6570-1860-c4ca1d680993@molgen.mpg.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 12, 2022 at 08:25:28AM +0200, Paul Menzel wrote:
> Dear Christoph,
>
>
> Thank you for the patch.
>
> Am 12.05.22 um 08:19 schrieb Christoph Hellwig:
>> Use the %pg format specifier to save on stack consuption and code size.
>
> consu*m*ption
>
> Did you do any measurements?

Each BDEVNAME_SIZE array consumes 32 bytes on the stack, and they are
gone now without any additional stack usage elsewhere.
