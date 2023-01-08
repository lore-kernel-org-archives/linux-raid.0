Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B52CC54EBC
	for <linux-raid@archiver.kernel.org>; Sun,  8 Jan 2023 20:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjAHUO1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Jan 2023 15:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbjAHUOF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 Jan 2023 15:14:05 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E64E0A9
        for <linux-raid@vger.kernel.org>; Sun,  8 Jan 2023 12:13:59 -0800 (PST)
Date:   Sun, 08 Jan 2023 20:13:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1673208834; x=1673468034;
        bh=+Vitxxs92Q05+uLb2QxzDstRdC/KMe74wLCn0vKA4c0=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=xuLxXqEjCDNFZOeBpdhMOGbf4EeVWnFcIUbTwpXF5bKl0V31VGtm+t91fivRFSUle
         IebAKdccIAkCAhNXW22PNSYT8E9VFT3gn2N+Q068FFNF0B7PjJTOyCXCNFGHkhgwLh
         n5ibJHQoJtl+wnwCDzW98aBFJseluHmED3nRVQR3J00tRQURB6G9t9DuSSCp7urQMN
         3Ez/ZH5giUhyKuW06jFFqrewER13LYq+yHE5WIU7IXgi7IHfIok3zLVslDYLe+x52Y
         OE5ynfK92TiJLcQ4kLyNRZhpidsuawfXuA+s8e1du4zoXoLdKvFmYSloNFMlRcZJ68
         yItt+1k1RNrZA==
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From:   boscabeag <boscabeag@protonmail.com>
Subject: Parity distribution when adding disks to md-raid6
Message-ID: <A73A8YRNkUS11zoz7eEaNfvnfZqyj6-vP-7mvI6_FFLdSETs_g6CFYgIL_PyV0F8AE6cXMomd7SznnsQDGQqwLuSJFMi8EbxGzxibvYjZ2s=@protonmail.com>
Feedback-ID: 42495234:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello, I hope I haven't missed finding the answer to my question. Thanks fo=
r taking the time to read this.

tl;dr

When adding new block devices to an existing md raid 6 array, how are the P=
 & Q chunks distributed over the new devices?

medium version

I'm replacing the drives in my home NAS and can't fully populate it all at =
one.  I can start with 4 drives, and create a raid 6 array.  When I add dri=
ves #5 and #6, will the parity chunks remain on the first four devices or w=
ill the resync process distribute them over the entire array, just like it =
would if I created the array with all devices?  Is there anything I should =
do (with mdadm) to an array after adding devices that's not just at the md =
level not the fs level?

details
It's a Netgear ReadyNAS, running kernel 4.4.218 and mdadm v4.1, a lightly m=
odified version of Debian 8 (Jessie) and there isn't a newer release from t=
he vendor.  It puts a single btrfs filesystem on top of md volumes.
