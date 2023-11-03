Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F496C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Nov 2023 14:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377761AbjKCOjT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 10:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjKCOjS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 10:39:18 -0400
X-Greylist: delayed 410 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Nov 2023 07:39:14 PDT
Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE4BA2
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 07:39:14 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by shin.romanrm.net (Postfix) with SMTP id B0D703F2BB;
        Fri,  3 Nov 2023 14:32:14 +0000 (UTC)
Date:   Fri, 3 Nov 2023 19:32:08 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Carlos Carvalho <carlos@fisica.ufpr.br>
Cc:     linux-raid@vger.kernel.org
Subject: Dirty page flushing regression in 6.5.x vs 6.1.x
Message-ID: <20231103193208.4968e7d8@nvm>
In-Reply-To: <ZUUA2U88VsGqGDmj@fisica.ufpr.br>
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
        <ZUUA2U88VsGqGDmj@fisica.ufpr.br>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 3 Nov 2023 11:16:57 -0300
Carlos Carvalho <carlos@fisica.ufpr.br> wrote:

> Johannes Truschnigg (johannes@truschnigg.info) wrote on Thu, Nov 02, 2023 at 05:34:51AM -03:
> > for the record, I do not think that any of the observations the OP made can be
> > explained by non-pathological phenomena/patterns of behavior. Something is
> > very clearly wrong with how this system behaves (the reported figures do not
> > at all match the expected performance of even a degraded RAID6 array in my
> > experience) and how data written to the filesystem apparently fails to make it
> > into the backing devices in acceptable time.
> > 
> > The whole affair reeks either of "subtle kernel bug", or maybe "subtle
> > hardware failure", I think.
> 
> Exactly. That's what I've been saying for months...
> 
> I found a clear comparison: expanding the kernel tarball in the SAME MACHINE
> with 6.1.61 and 6.5.10. The raid6 array is working normally in both cases. With
> 6.1.61 the expansion works fine, finishes with ~100MB of dirty pages and these
> are quickly sent to permanent storage. With 6.5.* it finishes with ~1.5GB of
> dirty pages that are never sent to disk (I waited ~3h). The disks are idle, as
> shown by sar, and the kworker/flushd runs with 100% cpu usage forever.

If you have a 100% way to reproduce, next what would be ideal to do is a
bisect to narrow it down to which commit introduced the problem. Of course it
might be not feasible to reboot dozens of times on production machines. Still,
maybe for a start you could narrow it down some more, such as check kernels
around 6.2, 6.3? Those are not offered anymore on kernel.org, but should be
retrievable from distro repositories or git.

Also check the 6.6 kernel which has been released recently.

-- 
With respect,
Roman
