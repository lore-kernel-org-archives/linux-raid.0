Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2719C05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 18:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBBSxU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 13:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjBBSxD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 13:53:03 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697EA86A6
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 10:53:00 -0800 (PST)
Received: from host81-147-105-30.range81-147.btcentralplus.com ([81.147.105.30] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pNehd-00055w-BU;
        Thu, 02 Feb 2023 18:52:57 +0000
Message-ID: <894cb7f7-eb13-69e8-8cd8-0f71dc34e489@youngman.org.uk>
Date:   Thu, 2 Feb 2023 18:52:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: how to know a hard drive will mix well
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20230202124306.GH25616@jpo>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20230202124306.GH25616@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/02/2023 12:43, David T-G wrote:
> Hi, all --
> 
> I have
> 
>    diskfarm:~ # mdadm -D /dev/md51 | egrep /dev/
>    /dev/md51:
> 	 0     259        9        0      active sync   /dev/sdb51
> 	 1     259        2        1      active sync   /dev/sdc51
> 	 3     259       16        2      active sync   /dev/sdd51
> 	 4     259       23        3      active sync   /dev/sdj51
> 
> Toshiba X300 10T
> 
>    diskfarm:~ # smartctl -i /dev/sdb | egrep '(Model|Number|Version):'
>    Device Model:     TOSHIBA HDWR11A
>    Serial Number:    61U0A0HQFBKG
>    Firmware Version: 0603
> 
> drives in my disk farm, and it's about time to grow again.  As I
> shopped around, I stumbled over a WD Red Plus 12T WD120EFBX drive at
> just $10 more, and who wouldn't want an extra 2T for ten bucks?  So I'm
> contemplating rolling in a different model.  But how do I know that it
> will fit well into the mix?
> 
> The X300 is a 7200rpm 256Mcache 6G/sec CMR drive.  The Red Plus is also
> listed as a 7200rpm* 256Mcache 6G/sec CMR drive.  They certainly sound
> equivalent.  What else do I need to consider, and where else do I need
> to look to learn?

I don't trust WD. That said, a lot of people do. I've got two 4TB 
Ironwolves, one 3TB Barracuda (slap wrist!), and one 8TB X300.

So mixing drives isn't a problem - just take a look at the Ironwolf - 
that might give you extra capacity too.
> 
> * The spec actually says "7200 RPM Class".  Does that mean not really
> 7200rpm?  That wouldn't surprise me in this modern day and age, and if
> the X300 also isn't really then that also wouldn't.
> 
> 
Drives now are "Constant Head Speed" not constant rpm. I'm guessing, 
that what it means is that for the inner tracks it spins at 7200, and as 
the heads move out, the rpms slow down to keep the speed the head is 
going over the platter constant.

Cheers,
Wol

