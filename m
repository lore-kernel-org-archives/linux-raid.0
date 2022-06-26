Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C762CC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 26 Jun 2022 16:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiFZQpG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Jun 2022 12:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiFZQpE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Jun 2022 12:45:04 -0400
X-Greylist: delayed 1195 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Jun 2022 09:45:04 PDT
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45994D107
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 09:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KC1eimRrWuBXJPDhEhKx3vCkY6qHeK1TcolzD5jvO0Q=; b=Ra4khXD2dvT8P+twed24f7vbIw
        pXNJ9DdIorQff0lvMBmk9SI4zxGTf1c4vp3B2I0HdIOIVkep8nDvzI2zEQr6z25zTfVUglafoTFld
        zeWrV4SfmfVdkxCN4Cp4p0KwFV3QruGsXg7vbh1lUigPydmRM5NPUOFaQoI9u05Xwt+6KgoZGwGV+
        53TjWuyB+XxJLOvBLeDbrR/aTUlFqNqVgrDTANPOPha9NBQGxVOveOS/PYT6hzygAnX10MBsMEbDU
        9rIXyqA6aowD3CWseOqmINelOlDjdbHdpDc3LjpR/qx0HM3CbLSy+D24pvgJ8Xa7+LpxC62zCnlhY
        nSmdIwWw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1o5V4M-0006dS-MR
        for linux-raid@vger.kernel.org; Sun, 26 Jun 2022 16:25:06 +0000
Date:   Sun, 26 Jun 2022 16:25:06 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
Message-ID: <20220626162506.txmbfrburd6wzzzg@bitfolk.com>
Mail-Followup-To: Linux-RAID <linux-raid@vger.kernel.org>
References: <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <a16b44a7-ae37-7775-24c8-436dcbe69ae8@shenkin.org>
 <cb10aa14-3a52-740c-4f6b-d7816cb31155@youngman.org.uk>
 <414a502b-dffd-d4cc-4eaa-579589877cee@shenkin.org>
 <6257be2f-212f-72ed-228c-324253910666@thelounge.net>
 <20220626034554.4bfe7388@nvm>
 <CAAMCDecEd1po2WpGT_SyimkJLoitRL-=RxKgDdsFA0LX7=2QuQ@mail.gmail.com>
 <c9897e26-a919-f594-55f3-f3256ceb9f87@shenkin.org>
 <3dedb344-7f0e-b82f-fe7f-ca56c42ecac4@shenkin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dedb344-7f0e-b82f-fe7f-ca56c42ecac4@shenkin.org>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Sun, Jun 26, 2022 at 08:44:12AM -0700, Alexander Shenkin wrote:
> 
> On 6/26/2022 8:34 AM, Alexander Shenkin wrote:
> > So, any idea how to disable hostonly?  I'm not finding it via google...
> 
> I should mention that /etc/dracut.conf doesn't exist on my system, and the
> dracut pacakge (if it is a package) doesn't show up in apt list, so I'm
> assuming it's not installed.  Does that mean I don't have hostonly
> installed?

This is a Fedora (and maybe other Red Hat-like) thing. On Debian how
generic your initramfs is, is set in
/etc/initramfs-tools/initramfs.conf:

    # MODULES: [ most | netboot | dep | list ]
    #
    # most - Add most filesystem and all harddrive drivers.
    #
    # dep - Try and guess which modules to load.
    #
    # netboot - Add the base modules, network modules, but skip block devices.
    #
    # list - Only include modules from the 'additional modules' list
    #
    MODULES=most

I think "dep" might be equivalent to this "hostonly" thing, the
point being to include only modules needed for the current hardware
configuration. Which might hamper an effort to move that install
into different hardware. It's not the default.

update-initramfs after changing.

Cheers,
Andy
