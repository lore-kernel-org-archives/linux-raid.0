Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8ADCC433E0
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 15:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EEF3650DB
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 15:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCPPVa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 11:21:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhCPPVH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 11:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615908066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ks00mpdAtCCxdE0OQgv4g8DW7KgLGB1WQvgSC9OgQK8=;
        b=WhBAQuZ6sw3XNz7/BaS9Eq49ziq8QDpc9Q5JQAVXIiMi/4A5yRyX119YKmzTKwoha6TmYo
        xEnbRdaNpfHf8KsaOOoBwU14+3xhx1DGrtQOffWt57xJ5iRlDgQMVrB+RLZLQStQppuHvl
        8O34T9nrbEUKM/Jh3SZnv5QB4S1rWAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-06annNaTNc6Q5DZjWUVjsw-1; Tue, 16 Mar 2021 11:21:05 -0400
X-MC-Unique: 06annNaTNc6Q5DZjWUVjsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC400800FF0;
        Tue, 16 Mar 2021 15:21:03 +0000 (UTC)
Received: from ovpn-3-68.rdu2.redhat.com (ovpn-3-68.rdu2.redhat.com [10.22.3.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E45C10023B5;
        Tue, 16 Mar 2021 15:21:03 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
From:   Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
Date:   Tue, 16 Mar 2021 11:21:02 -0400
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        xni@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CE9A135-5134-44E3-80F4-821E3386B279@redhat.com>
References: <20210120200542.19139-1-ncroxon@redhat.com>
 <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org>
 <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for the heads up Mariusz.

I will look into this now.

-Nigel

> On Mar 16, 2021, at 10:54 AM, Tkaczyk, Mariusz =
<mariusz.tkaczyk@linux.intel.com> wrote:
>=20
> Hello Nigel,
>=20
> Blame told us, that yours patch introduce regression in following
> scenario:
>=20
> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
> #mdadm -CR volume -l0 --chunk 64 --raid-devices=3D1 /dev/nvme0n1 =
--force
> #mdadm -G /dev/md/imsm0 -n2
>=20
> At the end of reshape, level doesn't back to RAID0.
> Could you look into it?
> Let me know, if you need support.
>=20
> Thanks,
> Mariusz
>=20

