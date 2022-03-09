Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F50C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 06:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiCIGJx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 01:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCIGJw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 01:09:52 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165AED4C82;
        Tue,  8 Mar 2022 22:08:50 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C6D3B68AFE; Wed,  9 Mar 2022 07:08:46 +0100 (CET)
Date:   Wed, 9 Mar 2022 07:08:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: raid5 bio handling cleanups
Message-ID: <20220309060846.GA31216@lst.de>
References: <20220228112503.841449-1-hch@lst.de> <CAPhsuW7EGxoyc9dkpP0y9AUWrV5V6ZORhew+tX=rFXS+vRm_AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW7EGxoyc9dkpP0y9AUWrV5V6ZORhew+tX=rFXS+vRm_AA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 02, 2022 at 04:14:40PM -0800, Song Liu wrote:
> On Mon, Feb 28, 2022 at 3:25 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi Song,
> >
> > this series cleans up the raid5 bio handling to take advantage of
> > the bio allocation interface changes in Jens' for-5.18 branches.
> 
> Applied to md-next. Thank

Unless I'm missing something these did not make it into the pull
request to Jens, right?
