Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA85C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jan 2022 03:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348279AbiARDJa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:09:30 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33020 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352108AbiARC6A (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Jan 2022 21:58:00 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4AA731F37F
        for <linux-raid@vger.kernel.org>; Tue, 18 Jan 2022 02:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642474679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=df4lKddMQqWsQBLOhcf1fc8T3hjR4l7GjHrFX21Ccy0=;
        b=rkepUuzn0XYMRGMR3g2EvSzQCoPaMiyz4gp70yu33rlVeiGK0lS0ZhghNnMDPhT5Cnm+v7
        9Fi/irgFsMYOdni44bXtkNqzziESuUE+9kLlDeGQ9QgjJ89qp6pR6OMNbZLUg4y812C5rQ
        LtdPXE5Tw4+ZRZMC406IHxWQAg+qBxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642474679;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=df4lKddMQqWsQBLOhcf1fc8T3hjR4l7GjHrFX21Ccy0=;
        b=XYG+WOjCHFJHsdD146IyjuJT58lRH3XvxbK7aOcBVrWnd7+85e3xXRoJnmt0G9mritVHJN
        8QlirkBMboxM9OBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B69CB13D88
        for <linux-raid@vger.kernel.org>; Tue, 18 Jan 2022 02:57:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iXuRHLYs5mGjZAAAMHmgww
        (envelope-from <neilb@suse.de>)
        for <linux-raid@vger.kernel.org>; Tue, 18 Jan 2022 02:57:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     linux-raid@vger.kernel.org
Subject: Documentation or support for IMSM caching ????
Date:   Tue, 18 Jan 2022 13:57:50 +1100
Message-id: <164247467024.24166.12368466830982210087@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi all, particularly friends from Intel....

Does anyone know anything about the caching support in IMSM soft-raid?

There are reports of mdadm complaining:

  mdadm: (IMSM): Unsupported attributes : 3000000

on some laptops - particularly an HP Spectre which has an SSD and Optane
memory.  Both devices has IMSM metadata, but mdadm cannot handle it.
Presumable the Optane is being used as a fast cache in front of the SSD.

If we had the specs we might be able to get mdadm to handle it.
Even better would be if Intel could provide some code :-)

https://bugzilla.suse.com/show_bug.cgi?id=1194355

NeilBrown
