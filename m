Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43255C433F5
	for <linux-raid@archiver.kernel.org>; Sun,  9 Jan 2022 14:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiAIOXs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 9 Jan 2022 09:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiAIOXr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 9 Jan 2022 09:23:47 -0500
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 09 Jan 2022 06:23:47 PST
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B665C06173F
        for <linux-raid@vger.kernel.org>; Sun,  9 Jan 2022 06:23:47 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc6b.ng.seznam.cz (email-smtpc6b.ng.seznam.cz [10.23.13.165])
        id 13bc3510bd2aba7017af5327;
        Sun, 09 Jan 2022 15:23:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1641738225; bh=PX8ea++rHXQndEciIcYbAlkoqkXvR3MFPZwjx9uvMg4=;
        h=Received:From:To:Subject:Date:Message-Id:Mime-Version:X-Mailer:
         Content-Type:Content-Transfer-Encoding:X-szn-frgn;
        b=IzDuHy/YdnktQbtkSeBx0GDT4rZp+CVgmcyy56V+yiz7RxBotAbFTn+pIlkbV8i9I
         IN2T5fqPsa9v3+PPUXV51hW8XeyxXAj3epFUhpRchmC1BtzK5zxxuJwLyfPt0aS2EJ
         O1PFBfw59shNM9HUE0HeG1aEtLTxNvex8qheCKuM=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Sun, 09 Jan 2022 15:21:13 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     <linux-raid@vger.kernel.org>
Subject: =?utf-8?q?Feature_request=3A_Add_flag_for_assuming_a_new_clean_dr?=
        =?utf-8?q?ive_completely_dirty_when_adding_to_a_degraded_raid5_array_in_o?=
        =?utf-8?q?rder_to_increase_the_speed_of_the_array_rebuild?=
Date:   Sun, 09 Jan 2022 15:21:13 +0100 (CET)
Message-Id: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <457ba8d9-1b72-47ca-9384-884e91a6fea7>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning everyone.

After a discussion on the kernelnewbies IRC channel I'm asking for taking =
this
feature request into consideration.
I'd like to see a new mdadm switch --assume-all-dirty or something more
suitable used together with the --add switch, that would increase the MD R=
AID5
rebuild speed in case of rotational drives by avoiding reading and checkin=
g
the chunk consistency on the newly added drive. It would change the rebuil=
d
strategy in such way It would only read from the N-1 drives containing val=
id
data and only write to the newly added 'empty' drive during the rebuild.=

That would increase the rebuild speed significantly in case the array is f=
ull
enough so that the parity could be considered inconsistent for most of the=

chunks.
In case of huge arrays (48TB in my case) the array rebuild takes a couple =
of
days with the current approach even when the array is idle and during that=

time any of the drives could fail causing a fatal data loss.

Does it make at least a bit of sense or my understanding and assumptions=

are wrong?

Thank you,
Jaromir Capik
