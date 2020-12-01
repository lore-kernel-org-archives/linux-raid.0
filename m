Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08259C64E7B
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A636204FD
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GeYkeRII"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgLAJ60 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgLAJ6Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 04:58:25 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD63CC0613D2
        for <linux-raid@vger.kernel.org>; Tue,  1 Dec 2020 01:57:39 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 4so853219plk.5
        for <linux-raid@vger.kernel.org>; Tue, 01 Dec 2020 01:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=g19pO6gyvwSOfov6SpOx5wZpiKh0v0KUikGgtQAx1BM=;
        b=GeYkeRIIPxG+NllPA8nsXyS57TBI8dIeY9rLsgbvl34egNM3K+wcggt5nefu5+PAa/
         gb9Iw3CTGORBdj5OI6MgVXUa6g/1wPHdoZgDqhKAF1kmbo4fjURHGnpURRia7aWTozMA
         gEr+DGqKcDf23+JUXQjVgwySTgNXCbK6oGIbCZUIzzhxZYw2PEmlvX/ri77AtBIBHf/D
         P10xquDdiBuoALtdM0mfc0o8J5B5cu5ASY0JalQTLr9axDKhq8ffaY+wi3uQ9oQEMf/E
         sE2AFMrokPqWKM9RbL68Bw0rTvqjE1+/aUkfwAFNI/t9Xv5TqxaNlK8iYvepS9zzuM6P
         B9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=g19pO6gyvwSOfov6SpOx5wZpiKh0v0KUikGgtQAx1BM=;
        b=TfLp1tfjrswl35VPKT4Rh7sFdlbKqw8/D+w4/y7B2eS1IbpAzOOTFSXcG1q9hQuVvH
         EOlhy+kFvOcgKWtO5gilrYHwe40/jibYh12mw8P4nsYeW1X2hdE03EtobBE4/6f27GPd
         pNjrrFVM9t8fU/eNn3eAv1gZ/wHoOQahcqsTLmAPo891SxoJ7tqBi9FxpcNoqIgeqxhU
         ejyciraDqLfp5odTlgUSsCyQfSBQLeStPMILx6Wih/j5Gca7TQtR7pDlGj4rM9nEQ6C3
         poQLoJ9oLFpIjYpv3NcfbpxGahTJnDsLU8Uy/YMTR5CLOcvr9vx714sxd0f+2Lngm5ZR
         5ZCg==
X-Gm-Message-State: AOAM531Ku2HHktJNhdt5O/MTh8ANttHgPiU/cYdk1/C1rR9VVCeNVaXZ
        kf+EXQsT048O5oAgVP2cLAqiQiiWutJFcPqAAIY=
X-Google-Smtp-Source: ABdhPJzRDcE5QB5ZJ4fwG8wXZQYnoTgPYbdDDO+5KWQFK3r1P52xP14GTDCHurw7q5iEr3/pBHTt3MKabXmY6Gf1rrU=
X-Received: by 2002:a17:90a:5d93:: with SMTP id t19mr1875394pji.220.1606816659283;
 Tue, 01 Dec 2020 01:57:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJH6TXjsg+OE5rUpK+RqeFJRxBiZJ94ToOdUD5ajjwXzYft9Vw@mail.gmail.com>
In-Reply-To: <CAJH6TXjsg+OE5rUpK+RqeFJRxBiZJ94ToOdUD5ajjwXzYft9Vw@mail.gmail.com>
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Tue, 1 Dec 2020 10:57:28 +0100
Message-ID: <CAJH6TXgED_UGRcLNVU+-1p8BVMapJkRmvZMndLYAKjX_j6f7iw@mail.gmail.com>
Subject: Fwd: [OT][X-POST] RAID-6 hw rebuild speed
To:     "General discussion - ask questions, receive answers and advice from
        other ZFS users" <zfs-discuss@list.zfsonlinux.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry for the OT and X-POST but these 2 lists are full of skilled
storage engineer.
For a very,very,very,very long time I used 15k SAS 3.5'' disks. A
RAID-6 hardware (8 disks) took about 20 hours to rebuild.

Now I've replaced a 3.5 disks with a 15k SAS 2.5'' disk. raid is
rebuilding properly, but the ETA is less then 1 hours.

I've moved from a 20 hours rebuild to about 50 minutes rebuild, by
just changing one 3.5' disks with a 2.5'

Is this normal ? I'm thinking something strange is happening
