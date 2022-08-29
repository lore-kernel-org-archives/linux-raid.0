Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19726ECAAD5
	for <linux-raid@archiver.kernel.org>; Mon, 29 Aug 2022 15:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiH2Pqq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Aug 2022 11:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiH2Pqp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 Aug 2022 11:46:45 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276BB832EF
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 08:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661787986; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=krqG0VzEDQAvvw0PpVDRyjTsg9fRdCnBYvbmBBqvQVI0wM6BHAeu8TK95QvC00wAyAAfGng/Ih6YdiyXci4lFGLKIpcAoRzT+d/xFEzMMk7NzSa8iNUq7SmghMuwkbhljM5SStAA2t4IpPBFHb3Z/Y+5JK4xni1+cvTLFE5ybvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661787986; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=KgCm+sgJr5ELMGvkkHvsP5zpsEcS+/8+7PvyrYRuk3g=; 
        b=DYeTFpSpMVbAWH8L6fAWchJflDnZp6qCl4tMXBk47EpZluIGxAhN+SCTm464d4MRHpPJ8df8b0dSrj4+y+MdVPjmPsqvriouMBfMhDXrJ1cmGFatF5DFPvzo7P7d8YjazxBwqO44DpMk+mehgcsyrAhY1taCztwVP3JtamB5GRw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661787982663944.2928229128063; Mon, 29 Aug 2022 17:46:22 +0200 (CEST)
Message-ID: <d0d69e71-7e66-122c-e1d1-8075aaa63e6c@trained-monkey.org>
Date:   Mon, 29 Aug 2022 11:46:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] super1: report truncated device
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>
 <20220721101907.00002fee@linux.intel.com>
 <165855103166.25184.12700264207415054726@noble.neil.brown.name>
 <20220725094238.000014f0@linux.intel.com>
 <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>
 <166138706173.27490.18440987438153337183@noble.neil.brown.name>
 <20220825095917.00002549@linux.intel.com>
 <571bde96-e70d-9c87-1544-49790844d160@trained-monkey.org>
 <166146815642.27490.8510532689362169941@noble.neil.brown.name>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <166146815642.27490.8510532689362169941@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/22 18:55, NeilBrown wrote:
> 
> When the metadata is at the start of the device, it is possible that it
> describes a device large than the one it is actually stored on.  When
> this happens, report it loudly in --examine.
> 
> ....
>    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
>           State : clean TRUNCATED DEVICE
> ....
> 
> Also report in --assemble so that the failure which the kernel will
> report will be explained.
> 
> mdadm: Device /dev/sdb is not large enough for data described in superblock
> mdadm: no RAID superblock on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
> 
> Scenario can be demonstrated as follows:
> 
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=0.90
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/test started.
> mdadm: stopped /dev/md/test
>    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
>           State : clean TRUNCATED DEVICE
>    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
>           State : clean TRUNCATED DEVICE
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---

Applied!

Thanks Neil!

Jes


