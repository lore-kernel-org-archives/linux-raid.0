Return-Path: <SRS0=ztYz=BW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2ABC433DF
	for <linux-raid@archiver.kernel.org>; Wed, 12 Aug 2020 21:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02B820774
	for <linux-raid@archiver.kernel.org>; Wed, 12 Aug 2020 21:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sabi.unospace.net header.i=@sabi.unospace.net header.b="iSnYrepT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLVtn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:49:43 -0400
Received: from azure.uno.uk.net ([95.172.254.11]:42918 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgHLVtm (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 12 Aug 2020 17:49:42 -0400
X-Greylist: delayed 3680 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2020 17:49:41 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sabi.unospace.net; s=default; h=From:References:In-Reply-To:Subject:To:Date
        :Message-ID:Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MDdYEuIrjj5FTZ9oAEg1ULZ0+OYCVfMuL7BVEwPah0I=; b=iSnYrepTtp+5Cowg41ANI7fvHp
        Xn2Spm8rgZ4KyHTdEPS277hsxiqRbGXC2VWJ6qmOnDnbVODSeLWI93dnFVtdglTaO1ihMKPPklygK
        r/Tsv9KIQ7LPEiaS99gpFIBppcOXlTW0/KxI1/6xmO/7KHn68iuFNCuypNxrHCloJzLGCKrCT9YqK
        c2Jth7mvk0qUwrhM/2ADt+5VjEBaU1nauABd7pFnqML4CYD243slrZcLi+FINdPJhiZjr0RWnQjN2
        oCcc+HP94UywmN001xoHdC2dQ15XAF7R/V7GRo6FSCLwwtajIYc9KqMWo3fR7hRZgayYnLTZ4Ye58
        rySkfyfA==;
Received: from [95.172.224.50] (port=51188 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1k5xfX-00007R-G8
        for linux-raid@vger.kernel.org; Wed, 12 Aug 2020 21:48:19 +0100
Received: from from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 5)
        id 1k5xc8-00ACJb-JI
        for <linux-raid@vger.kernel.org>; Wed, 12 Aug 2020 21:44:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24372.21693.71220.177848@cyme.ty.sabi.co.uk>
Date:   Wed, 12 Aug 2020 21:44:45 +0100
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Recommended filesystem for RAID 6
In-Reply-To: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - azure.uno.uk.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - root.t00.sabi.co.uk
X-Get-Message-Sender-Via: azure.uno.uk.net: authenticated_id: sabity@sabi.unospace.net
X-Authenticated-Sender: azure.uno.uk.net: sabity@sabi.unospace.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> [...] enough cheap 2TB disks to get started. I'm planning on
> creating a RAID 6 array due to the age and consumer-grade
> quality of my 16 2TB disks. [...] Use case is long-term
> storage of many small files and a few large ones (family
> photos and videos, backups of other systems, working copies of
> photo, audio, and video edits, etc.)? Current usable space is
> about 10TB but my end state vision is probably upwards of
> 20TB.

As other people have remarked a single RAID is not long-term
storage, RAID redundancy is designed for *online continuity*
(that is storage systems to remain available despite media
failures), not for "backup" or "integrity" (even if LVM RAID has
got some recent additions for that).

Also RAID6 is terrible for writing small files, small files are
bad for any filesystem type, and recovery times on a large RAID6
are risky. Also it is much better BTW to use 'ar' or 'zip' etc.
('zip -0' for already compressed files) to avoid many small
files, esepcially if they are part of a read-only collection;
most GUI tools can access archive files as if directories. Some
tools have checksums or even redundancy codes for members.

But overall the idea is that if you are doing archival a single
large storage pool is a terrible idea (it is a terrible idea in
general, but especially for archival):

  http://www.sabi.co.uk/blog/0805may.html?080516#080516

Probably your best options is to have a series of separate
smaller "silos" (or "data drawers" or "data shelves"), where you
fill one "silo" at a time, and when full it can become read-only
mounted, and then you fill the next and so on. An alternative is
to have two RW silos: one for archival, and one permanently RW
for home directories.

For backup you can buy some large disk drives, at least 3 (well
2 is the minimum but it is rather riskier), to use in rotation,
and partition them in the size of the "silos", and dump the
currently RW "silo"; with 'tar' or 'dumpe2fs' (or even 'dd' but
careful about duplicate UUIDs or labels), but not RSYNC if you
have many small files. The backups can be easily encrypted even
if the live "silos" are not.

As the currently RW "silo" fills up you keep backing it up in to
distinct backup disks, and once it is full you can stop backing
it up, and keep its backup disks on a shelf.

For example you could have a number of 2+1 or 3+1 or 4+1 RAID5s
as "silos", with a 4TB or 6TB or 8TB raw capacity and fill one
after the other, and then get 8-12TB drives, partitioned
accordingly. 4TB is for me is a good limit for "live" silos.

The filesystem type for the silos does not matter much, but I
like for archiving the checksumming COW filesystem types, like
NILFS2/Btrfs/ZFS (but I never use the Btrfs volume manager, I
prefer MD RAID by far, while the ZFS volume manager is
acceptable). Otherwise I like JFS (or F2FS or even UDF).
