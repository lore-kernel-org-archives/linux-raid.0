Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BE8C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Nov 2023 14:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377768AbjKCORN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 10:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjKCORM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 10:17:12 -0400
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0406D4B
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 07:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1699021017;
        bh=nGozF2PuxiJ6Cs9Ox9wTJatgDF1LLglnEFndWefqeJA=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ZjbooQQIKTRTkKvnb2MFDuRgtG9uSzXmSm6LHnqC4MzXzD5C4IaEr3R+9T09awYa6
         P5p+lf4WFB9B30W6gaAPI2tftf5DcXMmNsSwh/bz4nmKYXdfGAxzezh+Jt0QEKZdsr
         VpXXrYte/IXCoth877137/0ojLOOqdRPEnevSbRW4YvmrfbiZ6cLbnFs1DMAdZxsu+
         OoM8XsiVPX8HvWerGPck0noatFZDqPjbW6Q12Az9PsHdPDb+Bdmc8rVrRipbVBfRfe
         ll5ieYBV+m6Lnt5/8pQrADWVq2n1DRWgsaI+m8MZ0jJU2TrIHdcjcO+xZeTnQkXB8I
         fVF2frgbN7lzA==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id A6372362023C; Fri,  3 Nov 2023 11:16:57 -0300 (-03)
Date:   Fri, 3 Nov 2023 11:16:57 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     linux-raid@vger.kernel.org
Subject: Re: problem with recovered array
Message-ID: <ZUUA2U88VsGqGDmj@fisica.ufpr.br>
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
 <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
 <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZUNfK1jqBNsm97Q-@vault.lan>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Johannes Truschnigg (johannes@truschnigg.info) wrote on Thu, Nov 02, 2023 at 05:34:51AM -03:
> for the record, I do not think that any of the observations the OP made can be
> explained by non-pathological phenomena/patterns of behavior. Something is
> very clearly wrong with how this system behaves (the reported figures do not
> at all match the expected performance of even a degraded RAID6 array in my
> experience) and how data written to the filesystem apparently fails to make it
> into the backing devices in acceptable time.
> 
> The whole affair reeks either of "subtle kernel bug", or maybe "subtle
> hardware failure", I think.

Exactly. That's what I've been saying for months...

I found a clear comparison: expanding the kernel tarball in the SAME MACHINE
with 6.1.61 and 6.5.10. The raid6 array is working normally in both cases. With
6.1.61 the expansion works fine, finishes with ~100MB of dirty pages and these
are quickly sent to permanent storage. With 6.5.* it finishes with ~1.5GB of
dirty pages that are never sent to disk (I waited ~3h). The disks are idle, as
shown by sar, and the kworker/flushd runs with 100% cpu usage forever.

Limiting the dirty*bytes in /proc/sys/vm the dirty pages stay low BUT tar is
blocked in D state and the tarball expansion proceeds so slowly that it'd take
days to complete (checked with quota).

So 6.5 (and 6.4) are unusable in this case. In another machine, which does
hundreds of rsync downloads every day, the same problem exists and I also get
frequent random rsync timeouts.

This is all with raid6 and ext4. One of the machines has a journal disk in the
raid and the filesystem is mounted with nobarriers. Both show the same
behavior. It'd be interesting to try a different filesystem but these are
production machines with many disks and I cannot create another big array to
transfer the contents.
