Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C0EC6FA8E
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 15:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCBP5l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCBP5j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 10:57:39 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE13A2385B
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 07:57:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677772647; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=P54z9BdAKXTIJJk9x2L4VaD8PIkDJsoAfIirQDpeaT5Gk8+d1n/b32fIWfoD49sRNOfOJG1xUruCjk1skYST8FwSy9OptriGAP7ji+dPb3/qZggjdwrLQBeCHzuLQ/jgxNicvhs7yzrNW8BY+emvwVA3ZCG/nMHQsxoR+gJeLdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1677772647; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=o+wNR85yhiXyHefI+qteVamBA2nm8YtweeeU3xfSet4=; 
        b=S7brYBg8PLWHpkt3sTMAw2UNwPlmxeP84UGJTReRO+8DPYeiynLGb4G4NrwYU03ihASxSaeUCV23BVthe+iEvw1jgfQYtNP5Acmj7D4NORhyCF8tBc64O2l/UJykqw0npbf56KTNDDwPRNc3/lFZJVPzROf1DOMVuiBm4wZtUY0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1677772645367747.1167110535843; Thu, 2 Mar 2023 16:57:25 +0100 (CET)
Message-ID: <4d8054f4-5cd5-2b6a-4f6d-af33438fbe9a@trained-monkey.org>
Date:   Thu, 2 Mar 2023 10:57:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 8/8] udev: Move udev_block() and udev_unblock() into
 udev.c
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-9-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230202112706.14228-9-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/2/23 06:27, Mateusz Grzonka wrote:
> Add kernel style comments and better error handling.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Create.c |  1 +
>  lib.c    | 29 -----------------------------
>  mdadm.h  |  2 --
>  mdopen.c | 12 ++++++------
>  udev.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  udev.h   |  2 ++
>  6 files changed, 53 insertions(+), 37 deletions(-)

This breaks miserably for me on Fedora 36:

[jes@jes-t490 mdadm.git]$ make
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-Wimplicit-fallthrough=0 -O2 -DSendmail=\""/usr/sbin/sendmail -t"\"
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
-DVERSION=\"4.2-94-g47c22f0\" -DVERS_DATE="\"2023-03-02\""
-DUSE_PTHREADS  -pthread -Wl,-z,now -o mdmon mdmon.o monitor.o
managemon.o uuid.o util.o maps.o mdstat.o sysfs.o config.o mapfile.o
mdopen.o policy.o lib.o Kill.o sg_io.o dlink.o ReadMe.o super-intel.o
super-mbr.o super-gpt.o super-ddf.o sha1.o crc32.o msg.o bitmap.o
xmalloc.o platform-intel.o probe_roms.o crc32c.o -ldl -ludev
/usr/bin/ld: mdopen.o: in function `find_free_devnm':
mdopen.c:(.text+0x5f5): undefined reference to `udev_is_available'
/usr/bin/ld: mdopen.o: in function `create_mddev':
mdopen.c:(.text+0x6e6): undefined reference to `udev_is_available'
/usr/bin/ld: mdopen.c:(.text+0x8db): undefined reference to `udev_block'
/usr/bin/ld: mdopen.c:(.text+0x96f): undefined reference to
`udev_is_available'
/usr/bin/ld: mdopen.c:(.text+0xa84): undefined reference to `udev_block'
/usr/bin/ld: mdopen.c:(.text+0xef5): undefined reference to `udev_block'
/usr/bin/ld: mdopen.c:(.text+0x1106): undefined reference to `udev_unblock'
/usr/bin/ld: mdopen.c:(.text+0x11ce): undefined reference to `udev_unblock'
collect2: error: ld returned 1 exit status
make: *** [Makefile:220: mdmon] Error 1

Jes
