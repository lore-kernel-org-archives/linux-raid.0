Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B4AC4321E
	for <linux-raid@archiver.kernel.org>; Mon, 28 Nov 2022 20:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiK1UqA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Nov 2022 15:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiK1Up7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Nov 2022 15:45:59 -0500
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DDF2E9FA
        for <linux-raid@vger.kernel.org>; Mon, 28 Nov 2022 12:45:56 -0800 (PST)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 96B321E5B7;
        Mon, 28 Nov 2022 15:45:55 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id A8D2CA80DA; Mon, 28 Nov 2022 15:45:54 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25477.7682.651953.966662@quad.stoffel.home>
Date:   Mon, 28 Nov 2022 15:45:54 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: about linear and about RAID10
In-Reply-To: <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
References: <20221123220736.GD19721@jpo>
        <20221124032821.628cd042@nvm>
        <20221124211019.GE19721@jpo>
        <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
        <20221125133050.GH19721@jpo>
        <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
        <20221128144630.GN19721@jpo>
        <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Reindl" == Reindl Harald <h.reindl@thelounge.net> writes:

> Am 28.11.22 um 15:46 schrieb David T-G:
>> I don't at this time have a device free to plug in locally to back up the
>> volume to destroy and rebuild as linear, so that will have to wait.  When
>> I do get that chance, though, will that help me get to the awesome goal
>> of actually INCREASING performance by including a RAID0 layer?

> stacking layers over layers will *never* increase performance - a pure 
> RAID0 will but if one disk is dead all is lost

> additional RAID0 on top or below another RAID won't help

> your main problem starts by slicing your drives in dozens of partitions 
> and "the idea being that each piece of which should take less time to 
> rebuild if something fails"

> when a drive fails all your partitions on that drive are gone - so 
> rebuild isn't faster at the end

> with that slicing and layers over layers you get unpredictable 
> head-movemnets slowing things down

> keep it SIMPLE!

This is my mantra as well here.  For my home system, I prefer
symplicity and robustness and performance, so I tend just use RAID1
mirrors of all my disks.  I really don't have all that much stuff I
need lots of disk space for.  And for that I have a scratch volume.  

I really like MD down low, with LVM on top so I can move LVs and
resize them easily (grow only generally) to make more room.  If I
really need to shrink a filesystem, it's a outage, but usually that's
ok.

But keeping it simple means that when things break and you're tired
and have family whining at you get things working agian, life will
tend to end up better.

Slicing HDDs into multiple partitions and then running MD on those
multiple partitions just screams of complexity.  Yes, in some cases
you might get a quicker rebuild if you have a block of sectors go bad,
but in general if a disk starts throwing out bad sectors, I'm gonna
replace the entire disk ASAP.  

Now if you have a primary SSD, and a wrote-mostly HDD type setup, then
complexity might be worth it.  Might.  

