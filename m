Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FC8C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 30 Dec 2021 19:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbhL3Twy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Dec 2021 14:52:54 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17009 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhL3Twy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Dec 2021 14:52:54 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1640893968; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jP3YvcjEluAM7RTS9SxXgnZuvuGO0iNDdbeCr0K03sRMhNvUBwIO33c6gNiAw9PXyKWr0ZNA9hKKwvqkUac33qjw6/m/BMfpsS6Jcw699TuLF3jKabT2T711HK8f8Gqcz35OmUUlFXl266mWQg7pWdGqTR6idF8ObyuXySzKjh0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1640893968; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=kcVtzsAyctx6LX230HJriRgD5LLoVC8q9t3HlpHU5Gk=; 
        b=K3pQVnsRk+RDqkyt5FmGhZIjPhe94VchRBnCrxFJ2h33rBDuXC8cr4o5G6+ZOl+nnjwISFgTKaToQYdDW2VtJfbgqVdJ1/vylj+jaC5itsXo725aA357jcuR0ixXloAzmJUMQ1y3FvzRu1sMBXp2sF1UNMvXZsSA4c+y9LlaAig=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1640893966504906.1598330846416; Thu, 30 Dec 2021 20:52:46 +0100 (CET)
To:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Subject: ANNOUNCE mdadm-4.2
Message-ID: <28fdbc45-96ca-7cdb-3ced-a5f65d978048@trained-monkey.org>
Date:   Thu, 30 Dec 2021 14:52:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Finally here it is, mdadm-4.2. Thanks for all the contributions and your
patience.

Happy New Year everyone!

Jes

From the announce file:

I am pleased to finally announce the availability of mdadm-4.2.
get 4.2 out the door soon.

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
   http://git.kernel.org/cgit/utils/mdadm/

The release includes more than two years of development and bugfixes,
so it is difficult to remember everything. Highlights include
enhancements and bug fixes including for IMSM RAID, Partial Parity
Log, clustered RAID support, improved testing, and gcc-9 support.

Thank you everyone who contributed to this release!

Jes Sorensen, 2021-12-30
