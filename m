Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27248C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 03:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjJaD3v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Oct 2023 23:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjJaD3t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Oct 2023 23:29:49 -0400
X-Greylist: delayed 498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Oct 2023 20:29:45 PDT
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE32B3
        for <linux-raid@vger.kernel.org>; Mon, 30 Oct 2023 20:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1698722475;
        bh=1NPllQG0ozVDoeyjmzGsOTWyOy1ckwayYEyek5UUThg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Rg1rGIcZnjv2Ky+pvMOHUBXcj9BB7BgOkoL+HBF6jW1Z8ktJo9YyyH3kQflsrM92n
         EOutWhaqKSB1WgMvQNmprBULXWDtI+iX7X1f+q8mGyEvwcA2J2IvzecLHunA/qAYsl
         +w5r/UaHytmkRcXSjLY7Y1J6a45kWqFPKB2IuppoYd1LMtsl9gRziSh4n0VOYgTKVD
         o17TSWkacltzmyQBoIJ5dE/bLM1r4piknvohlULMYNOjuuT4NhaNnux7331w/L8ni6
         3B1zfrZkUBH6d1k4lB4pNGk5zY1PRVWxEg6Fn0El4CPSpYdHltiX2sW9bTVaMLnM7Q
         5MTA1oqt9PUHg==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id 5388E36202D1; Tue, 31 Oct 2023 00:21:15 -0300 (-03)
Date:   Tue, 31 Oct 2023 00:21:15 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     linux-raid@vger.kernel.org
Subject: Re: problem with recovered array
Message-ID: <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at 01:14:49PM -03:
> look at  SAR -d output for all the disks in the raid6.   It may be a
> disk issue (though I suspect not given the 100% cpu show in raid).
> 
> Clearly something very expensive/deadlockish is happening because of
> the raid having to rebuild the data from the missing disk, not sure
> what could be wrong with it.

This is very similar to what I complained some 3 months ago. For me it happens
with an array in normal state. sar shows no disk activity yet there are no
writes to the array (reads happen normally) and the flushd thread uses 100%
cpu.

For the latest 6.5.* I can reliably reproduce it with
% xzcat linux-6.5.tar.xz | tar x -f -

This leaves the machine with ~1.5GB of dirty pages (as reported by
/proc/meminfo) that it never manages to write to the array. I've waited for
several hours to no avail. After a reboot the kernel tree had only about 220MB
instead of ~1.5GB...
