Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=BAYES_40,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E062CC433E1
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 19:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73BBA206BE
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 19:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=@mailfence.com header.b="O/vAMiaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgHXTjO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:39:14 -0400
Received: from mailout-l3b-97.contactoffice.com ([212.3.242.97]:33834 "EHLO
        mailout-l3b-97.contactoffice.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726700AbgHXTjL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 Aug 2020 15:39:11 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2020 15:39:10 EDT
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
        by mailout-l3b-97.contactoffice.com (Postfix) with ESMTP id 9D27642E
        for <linux-raid@vger.kernel.org>; Mon, 24 Aug 2020 21:33:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailfence.com;
        s=20160819-nLV10XS2; t=1598297635;
        bh=b5xqtOqJxvIViUoPo4F2u+ou0WwJu6syVh+HilmDBKc=;
        h=Date:From:To:Subject:From;
        b=O/vAMiaEh0n1cWPgaJzkpzVUBwZuF8nlASDcQzcsiw6zS7ec1VBVaXRemENaq2TEL
         CQEbljO+PDje63A4zw6EaupqMb7MVGyWIgBCTT85roodjvjfQqGmD26+wiGW+155RH
         ehmAQ0Xfo/E5JQjZzNfCINXbwaeyTS3HEe2KxdOvWhPETVA8v+OAGZGwU/Q81lEqzD
         XD41VSku7I9GR6EJkqbKbzjp6Jw3Mg01MI6PubcnEqGheSaTko+rLql0QFogCspyfb
         saAnfXKTnsxFpY50MIvpTkI+w4Q7wiLZ2gv78QBEiUoTQraq/dMZc0cIhnHxXIBA5Z
         gSxrAF3m0jkbg==
Received: by smtp.mailfence.com with ESMTPA
          for <linux-raid@vger.kernel.org> ; Mon, 24 Aug 2020 21:33:52 +0200 (CEST)
Date:   Mon, 24 Aug 2020 21:33:53 +0200 (CEST)
From:   grumpy@mailfence.com
To:     linux-raid@vger.kernel.org
Subject: increase size of raid
Message-ID: <nycvar.QRO.7.76.2008241430040.28072@tehzcl5.tehzcl-arg>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-ContactOffice-Account: com:191882055
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

i have 2 6tb drives
i use a 3tb partition on each drive for raid 1
i want to increase the size of the partitions
what are the steps for this that will result in the least likelihood of me screw'n up my system
thanks
