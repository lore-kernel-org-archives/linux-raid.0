Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3183EC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbjJZVpO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbjJZVpM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:45:12 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC251D4A
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:44:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356684; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XDuYK1vDANdY7fFCfzWwudBzGMcCp5y64OAJuli5z/poOBGRVuIniqRbpPtJviOU7cEwT7l91nssZjLaqpi9kY2tB7IAjJZAAyK8xWXbNJHiev+hE2X/3nQ+f6A65N2Tzis1Y60Rj05qHRkScCpxrBOefIJ9MS4T+D54lMTe/Bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356684; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=O5+tE0nY0r/CXM/e7HGcE46kqDINsY1aaeM7NbOOvCM=; 
        b=WlEbXIxt4cokcsi7gnSFQcI1ThAo4pQA26VCZfFBrwZQIuYgnnrp+fK9/a5aPbHa+bfZSpYFGveBSu9PNK71O/dUVg0/376yvgrRQ7IsYA0RjGO06OgRdX0+kX8X0Y+hqCdUT5lKGTX45wPsKTaFV0l7TXPbmSsD2AAXtpQKh2U=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356680856276.0560432126026; Thu, 26 Oct 2023 23:44:40 +0200 (CEST)
Message-ID: <01d007e1-9d44-8eaa-df31-25bbe767bef4@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:44:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/4 v2] mdadm/tests: Don't run mknod before losetup
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org
References: <20230927025219.49915-1-xni@redhat.com>
 <20230927025219.49915-3-xni@redhat.com>
 <20230928112752.0000135b@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230928112752.0000135b@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/28/23 05:27, Mariusz Tkaczyk wrote:
> On Wed, 27 Sep 2023 10:52:17 +0800
> Xiao Ni <xni@redhat.com> wrote:
> 
>> Sometimes it can fail:
>> losetup: /var/tmp/mdtest0: failed to set up loop device: No such device or
>> address /dev/loop0 and /var/tmp/mdtest0 are already created before losetup.
>>
>> Because losetup can create device node by itself. So remove mknod.
>>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---

Applied!

Thanks,
Jes


