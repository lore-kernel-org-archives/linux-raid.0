Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779CEC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 14:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbiBIOrA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 09:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiBIOq7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 09:46:59 -0500
X-Greylist: delayed 100 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 06:47:02 PST
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D0BEC0613C9
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 06:47:01 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-242-qivUEKu-Nx-csT-ffmbl5A-1; Wed, 09 Feb 2022 14:45:19 +0000
X-MC-Unique: qivUEKu-Nx-csT-ffmbl5A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 9 Feb 2022 14:45:18 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 9 Feb 2022 14:45:18 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David T-G' <davidtg+robot@justpickone.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
Thread-Topic: [PATCH v2 1/2] lib/raid6/test/Makefile: Use `$(pound)` instead
 of `\#` for Make 4.3
Thread-Index: AQHYHbrjaaGrMTB3M0ipeBb59E9eX6yLST5A
Date:   Wed, 9 Feb 2022 14:45:18 +0000
Message-ID: <6879dfb9fd594925b348fbbbf0051670@AcuMS.aculab.com>
References: <20220208152148.48534-1-pmenzel@molgen.mpg.de>
 <d07a9d41-5a8f-a1f3-59f7-d2a75d6df2e5@youngman.org.uk>
 <20220209134139.GA4455@justpickone.org>
In-Reply-To: <20220209134139.GA4455@justpickone.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: David T-G
> Sent: 09 February 2022 13:42
> 
> ...and then Wols Lists said...
> %
> % On 08/02/2022 15:21, Paul Menzel wrote:
> ...
> %
> % As commented elsewhere, for the sake of us ENGLISH speakers,
> % *PLEASE* make that $(hash). A pound sign is £.
> 
> Or, even better, $(octothorpe) since that's merely a symbol rather than a
> food product or a result of an algorithm on data.  You might even hope
> that we hash this out eventually ...

I was more worried that people might think we should smoke the hash.

The # symbol called 'hash' in the UK. Can't remember why - but it is used
to mean 'number'.

'octothorpe' is some brain-damaged name and should be shot^Werased on sight.

The whole UK v US confusion about what a 'pound' sign looks like almost
certainly led to UK ascii using the £ glyph for 0x23.
I can imaging a phone call where a US person said '0x23 is the pound sign'.

I remember problems with ascii peripherals on a ebcdic mainframe where
£ $ # and \ had to get squeezed into the three available codes.
Not only was in semi-random what a line printer might print,
we had 'page mode' terminals where the input and output translation
tables didn't always match.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

