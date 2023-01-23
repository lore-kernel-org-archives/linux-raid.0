Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62B0C25B4E
	for <linux-raid@archiver.kernel.org>; Mon, 23 Jan 2023 00:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjAWAZ2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Jan 2023 19:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjAWAZ1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Jan 2023 19:25:27 -0500
Received: from mout.perfora.net (mout.perfora.net [74.208.4.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FADA193CD
        for <linux-raid@vger.kernel.org>; Sun, 22 Jan 2023 16:25:26 -0800 (PST)
Received: from android-e41ce0186a96148b.home ([72.94.51.172]) by
 mrelay.perfora.net (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id
 1MTisb-1p7M1k3UOz-00U4Jz; Mon, 23 Jan 2023 01:25:22 +0100
Date:   Sun, 22 Jan 2023 19:25:11 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <4cb62cde-a8c3-1d02-207f-efb903301255@youngman.org.uk>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com> <deafcb4a-ed1c-d0b3-c9f9-c0a99867bb7a@meddatainc.com> <3CEAC9AB-02FC-43BE-94CF-ED3ECFF6F4F7@meddatainc.com> <4cb62cde-a8c3-1d02-207f-efb903301255@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: Transferring an existing system from non-RAID disks to RAID1 disks in the same computer
To:     Wol <antlists@youngman.org.uk>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
From:   H <agents@meddatainc.com>
Message-ID: <3B555415-E47B-4E06-AC05-119B5A4B138F@meddatainc.com>
X-Provags-ID: V03:K1:ggyipQ4pqwMQj+JnhXIob0pwJ6KhR3P0kbl7janGms84IUMS9WS
 muxGFcdadqJex5SL84G0HhNsPfTH4ZRrhtu4AoP7mHKOxObDYvmKJZTJBVXMnfkR4NYXpsn
 u+qBYSAMZUoB9THTIbp4AhFYyPXNr8LGsZDLMQD/DBr/guOc4/NpQzWcSPzXojv/mZadxod
 KAmYstxAnPyDENO1AczlA==
UI-OutboundReport: notjunk:1;M01:P0:jUiCq19yICI=;juS3rFtuKIjNt8o2l/EN0mWf63f
 k0sgX+lv2FxZ1jfBjxFSp4pHLZ02xZoKeW+eJiujnnWrF3xTPdUG161g3zIfx8nIbgEYGLbNj
 X+77dMdubU3QqkNGOAioLOwfVR/wmyf725oZqkWi0RisFb1YyvEj+MU5iGL/2qhcOta5JTp/+
 SsCpRrQ/0wNm8pV/XzD0zQo2SRKg3jhTTjrLhX2aSxpnVTwMq+KLyoUcKobef4tskb1Z8Dp5C
 YeSKvpAxSZ6Y3EsgdhUOYhw0DcjGrhViVJ7P6WOShOTa11TLGQn/GK6OjiXuIQooEyaqiKgTn
 nyGTVXRJOBjtjUwklRLQRhqu2c+YAkEveC5KzwLsRCK3S/a0MzBHrfa6DABLfxHvRCcCo2Wqy
 UB0yb8rsBkWw9m7jbP6+F6iFdBjJiWhVTYWcduWpP2UvWrzBK8pRD1YcXP5mKbVLkOCEKqLpY
 pLDdpxkU6jrS8HVx2rRp0SnmuRixVtPoa5UiV675JJtKXSooJvcD+31j6gq2yWbXPGrUFJ/YR
 oBrWqOpP6lm7yDWO/XekHl4aWiPy4k3IkejiCr/GEFRprla/BiDrrF0/jvpQXUSTpL3bJHhRq
 b36+e9zt9y3Q6HRQn+xKb9jKcsmInS49lRN8a1VeZVHtHPyKUzokbiMtxtH0ZIRQM2rJOZjAA
 gYdmytq4pKAzeBVbtwmUgjw9DILATbJo43xyYrwsAQ==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On January 22, 2023 12:19:36 PM EST, Wol <antlists@youngman.org.uk> wrote:
>On 22/01/2023 05:05, H wrote:
>> However, going back to the issue of /boot/efi possibly not being
>duplicated by CentOS, would not mdadm take care of that automatically?
>How can I check?
>
>mdadm/raid will take care of /boot/efi provided both (a) it's set up 
>correctly, and (b) nothing outside of linux modifies it.
>
>You can always run a raid integrity check (can't remember what it's 
>called / the syntax) which will confirm they are identical.
>
>But if something *has* messed with the mirror outside of linux, the
>only 
>way you can find out what happened is to mount the underlying
>partitions 
>(for heavens sake do that read only !!!) and compare them.
>
>A bit of suggested ?light reading for you - get your head round the 
>difference between superblocks 1.0 and 1.2, understand how raid can 
>mirror a fat partition and why that only works with 1.0, and then 
>understand how you can mount the underlying efi fat partitions 
>separately from the raided partition.
>
>Read the raid wiki https://raid.wiki.kernel.org/index.php/Linux_Raid
>and 
>try to get to grips with what is actually going on ...
>
>Cheers,
>Wol

Good to know. Thank you.

By the way, I had not set the partition labels when I installed on the new disks and I see that they became localhost:boot etc, all of the labels start with ”localhost:”

Is there any reason I cannot simply use gparted in CentOS to rename them, ie removing the ”localhost:” part” while keeping the second part of each label? I understand that could have been used in fstab but I have not done that.

Any other place they could potentially be used or is the renaming above safe?
