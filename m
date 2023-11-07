Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F45CC4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 21:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbjKGV0t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 16:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbjKGV0s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 16:26:48 -0500
X-Greylist: delayed 717 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Nov 2023 13:26:45 PST
Received: from SMTP.sabi.co.uk (SMTP.sabi.co.UK [185.17.255.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE1512F
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 13:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=root.for.sabi.co.uk; s=dkim-00; h=From:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version;
        bh=L05iO621kn3z5s8mLV4n6szV+67NZjefY1hZn/rJcks=; b=u/TA+ZeufSMUiOkahMszNd3Xwt
        OvgUkLMUulnHL2vwlOUauVeK1zvBQt7uj6KnWxDPpyoepUR1s1CZseqS8cJTuLjx3wvV7YBDgaZm3
        /3mzgNOcnzx+b0lvtK0hxOy8iyTN/aOF+hKOdgFnLQTe3bS+EQ3A6MxCiPqpgqR2X+xNhgdY2RI70
        9ca3fOZ9MJrvRqbJUMsUcqggx/pXF3xJfzOw6Az0IcCnOJ69XKbMUOonO5LijN9Cc+Fsxr/fyO80i
        8zCJ9jHM81nAPN+u6xkzOk0ceLAAIXBEemn57fmdmb9Sl7YX0eTOaKG3KfrWiuAexswVFG4Q1vz+p
        k51orO7Q==;
Received: from [87.254.0.135] (helo=petal.ty.sabi.co.uk)
        by SMTP.sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
        id 1r0Tau-007MGv-1Tby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Tue, 07 Nov 2023 21:26:44 +0000
Received: from localhost ([127.0.0.1] helo=petal.ty.sabi.co.uk)
        by petal.ty.sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
        id 1r0Tar-000akk-5w
        for <linux-raid@vger.kernel.org>; Tue, 07 Nov 2023 21:26:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25930.43920.984399.596968@petal.ty.sabi.co.uk>
Date:   Tue, 7 Nov 2023 21:26:40 +0000
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Issues restoring a degraded array
In-Reply-To: <CAE1wYva7ArH+=okXPWBG7r7EYj-3_Ph3OM3OXHvGLEHOp+tK-A@mail.gmail.com>
References: <CAE1wYva7ArH+=okXPWBG7r7EYj-3_Ph3OM3OXHvGLEHOp+tK-A@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I have a 14 drive RAID5 array with 1 spare.

Very brave!

> Each drive is a 2TB SSD. One of the drives failed. I replaced
> it, and while it was rebuilding, one of the original drives
> experienced some read errors and seems to have been marked
> bad. I have since cloned that drive (first using dd and the
> nddrescue), and it clones without any read errors.

So one drive is mostly missing and one drive (the cloned one) is
behind on event count.

> But now when I run the 'mdadm --assemble --scan' command, I get:
> mdadm: failed to add /dev/sdi to /dev/md/0: Invalid argument
> mdadm: /dev/md/0 assembled from 12 drives and 1 spare - not enough to
> start the array while not clean - consider --force
> mdadm: No arrays foudn in config file or automatically

The MD RAID wiki has a similar suggestion:

  https://raid.wiki.kernel.org/index.php/Assemble_Run

  "The problem with replacing a dying drive with an incomplete
  ddrescue copy, is that the raid has no way of knowing which
  blocks failed to copy, and no way of reconstructing them even
  if it did. In other words, random blocks will return garbage
  (probably in the form of a block of nulls) in response to a
  read request.

  Either way, now forcibly assemble the array using the drives
  with the highest event count, and the drive that failed most
  recently, to bring the array up in degraded mode.

    mdadm --force --assemble /dev/mdN /dev/sd[XYZ]1"


Note that the suggestion does not use '--scan'.

  "If you are lucky, the missing writes are unimportant. If you
  are happy with the health of your drives, now add a new drive
  to restore redundancy.

    mdadm /dev/mdN --add /dev/sdW1

  and do a filesystem check fsck to try and find the inevitable
  corruption."
