Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C0DC47082
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 09:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 228046008E
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 09:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGJ5N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:57:13 -0400
Received: from sonic312-26.consmr.mail.gq1.yahoo.com ([98.137.69.207]:42454
        "EHLO sonic312-26.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGJ5M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Jun 2021 05:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1623059721; bh=lKyfdtnRIBp4cEu+L3SPr0Wfza0d2oNoPgQqk3d9Y10=; h=Subject:From:To:References:Date:In-Reply-To:From:Subject:Reply-To; b=qAM9rdMceFJl7IME1b+TbRjd/9VTUJBRJyqAnj0wFICQE6/Ygqod4E0XfNp9H3cDXnvJc5RzEbfxD4qPnH6Ch7h+XxTmlrghqd8JGHXnAZzOZBl3Ti1EVx5ORD1dScGf3I/k7G9MpUKRKiyd6rsLhg46dz5ADMyLWDFzQaycYKc=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623059721; bh=kQ9ECin8iwq5BUjCl5RpfTqjRP0z/7TYnlL98uXBW+r=; h=X-Sonic-MF:Subject:From:To:Date:From:Subject; b=EhiQ2lHAp7qPpRdf/cTXqN4ca+6vwm/eClKgS2dOmSYM+M5ctJm2xUD6agdQbSVdds1P3dfkR79rJm4E30Wz7aQFmbmPWq44dmnRRn6nli6mYP6JaFE5W7GXpDivuvCHAIInvezcdFy6RKcH7qtGntqR8QQU1z1s0rnpV2NdPgDkEFgQyZBuOX7e+S8PPTW4qK62M5qzWauv+JosJyXs+07KirF+F4XQ3fxtSA9hRy6YUjW7Y55bmbdvpxqBjm/qrJb8JwlttprvmQw2MXdAYyJ+yV8++NqPynhVTJZpmi9t3WAzJ3mKCx6W3RFZNAxh4OxVD0HryOr2z4EkXJyAiw==
X-YMail-OSG: uZ7V_W4VM1kvRvY7kUfg2J3LRBhsQZrTkycZgnHts8D06wWW691m.Z4D4wiYNCq
 i4YMxkSHvPUUCXF8o84q0bjjk8cEe59Z.zunDM26QGbLGovZXZeB4Pzwi.w_VAjOECkbTbuIY13O
 aZd248GFeuxoXTEZv2UusTdJjKMjHmQ4w9PokdTVhquvfdW4AyDg.T51IVqt2T9Px7OKL5nZAc9c
 ty3CZHLH8ZXTeACW4zPeHY7xHoZ8LyVZopFcQjheNhfsz7_MQcEWh4BLY9H_lXT6hF4fKGjFQb.j
 _9ENQkyrpmn7yH0amlhr6Rl3u2pOj57ux6Y.l8YDXBGOTmrwPZzWlJmDQIYlNdk.mguWeM28lei.
 CqY7zWmgwUnZM3hVPxPfakOG3gfnGXOYT6LIUe6S8DiEiPv5qKTFs1eMtWZ.ZUUyLJTqoz1oRf4r
 beM8I3USTx4GJBDKFZ5K5Qd0Mcc8k2m6sSpPyGrXYM.77ORjsCl49DtravxyXje20.6sxE1Y0HN8
 efoKUjuXbcDtUhDwrleoU8sW3P5N4SH4eey1isjwPs8x6KBmULogk1dXTrTR75XVIadAAX8daOLJ
 kgxXqFMBuYGWLZtbgHnT3rVq18b0xsN_1ePIkcpROJ07HeKTVY.T_lGFwK2Q_5tuEN2omXg446ns
 TSw7eC6HgpvCCPdRu8VrxF_rmIZ535Iot0tUkpA8aHi5K1AnHHCHYXEiOdRV3yxRolwQs2SuJWir
 IZ0QBGSjwPVF3WH9fVtFhW7nFavTVmVrgb0z7QYra9oz3wlbTahAPxYE5fyPGfxpv50PROxw4xgX
 GEeLWo74kFqAEnzQkJac29AcGgVNHSWHvHCAL7WkDgkFYZR9O097llwKlgKZPL8mtinleAJ2WfMe
 33hEYKkkUM5trJ0BJ49iXDM6iA7NzVhBmzZucViGitJxZxP3FHvf5zriRCAEntXVjUXUTuKpX_81
 YTdwQb5UOx828VplN3sQwn6S8ahAyidPm0mHKm1_BvS0jU2_W65xUfsmv4PYT5fmht4fh.f6AZm_
 zNcDBeExaCadM4K1nmkvqFnSyP7J6kHl0ecdWqBHJ9nqKYD259dJbxZBgZid8WeYQ8K9xlqZi_Od
 JxIgP2v3VVp66NASxEVlOdn07p1H1WequgEIkh.9_6HHILc0mtCIOIR8W7ADfItI5gXnkbIEv7y3
 QRMMxq25YjppLpzwMtifUwvnSuSTfBEgVkcT3JjtuWUVJyRsAtAh9BchujPjXP7aFhfk6DEOeptQ
 28p.35SyU0pXsYdL4wW.kb08exFWdm5mWZs1.xcGEu4f6fUjPKtLCHCmxCgzciFUt6HOE3hiRVHv
 XQBGiGUqROrafUnKDjJLRs6Eu7CVzTRn0Qi3mnG6S7JdjS7XQaju5EKLHlj9xHas9PPJBi38t8RC
 PpFSeWJsBKOIsN10ZwAnq6MqZBKP61Rqc5KLvoY4mlhrojvnbOTRgvL7pzyzWnt24IBUjv9IUuWU
 Ndg7pti1N_Rjna_LXdGbgsjbzad3v_nKq.4rwwbV2QouIb_8FYmk1rHCIQ.cQIoyuARDGgk5beHG
 tcSfyTb413KWPXEsdHyELcB8z4vhy0RotEXki2r4.DvHbHH1oFITAgVpYrWxBq5qWGGU0ccnb7bk
 .3yDd9893BXJeeAGYNaGCG8.iLFuCVpNYa8woRoSge65vSp4wzZlLNACup6kDFDP241jJ5lqUV1F
 FHeJKQ6rfeI2MqOw0CgaebFocr8KKrMXERbhrCvqtZzjPLAyYLmIlv.cJwLYNy1ik.RKl.0gp4Ns
 7uvqpTY.6uaKeNcfR5rKNpSN8szYWTDBDkbLiM2eMYewLpE313lnC5nqNVDcSpkpsUkr8Wsj7.o9
 VIN_TOUaZcH_qg.L.LzPLhJ_xCFqcbE22.YFrphb8dvBtwT06tcBM1hhgkeFmhw6zsWlo55nnGG0
 yoIygM7BrBHSJKhLMF.Vfkr80PYSdJ6NUD_HCecfX6RS2w1YIzlhbcIdSRH2nWBeEcsD0ZyHnDQH
 bkQ8mJqoKX4.d_Xx2g4mw2OqUQN4T3rQj5yuD1A4zHoToWJSF.9c2ezai_8SZi1w8KTegeFaKMVg
 rX1AzrL0WjEmeX3cCpuRJ6RqYhufi9nmE1etugDZlbTHD7rrtruuNHWNbLpeHlh0LnsytikYLIUr
 VgypLMPtf9WE1Kw_omRR98E8j2up6wXFt1nD.mAn5jbe2v02lsKZSUlenFUb5nGDg0u10AWskL5z
 njvNI0b5Byq5HcidHWCPXmptnHp1eLEkygwWsRCLKhOaOBRmhuhJfc.x7lRP_XPgV4z0kxQsbXnE
 7iRiostnxAkX9JYML8HGfZeDLhII2Zcbmx6R_iQGquFJLBhkv8Cq1G1snxBxW.CtS1Sexh6W5E6E
 qCT6nKXHpB5sV8q5VnG1sdofTfP1hyHQ9y0qwW3TIGYWqFB6CMvSYDIXwJjBO5VrsSqcFFQNDO7e
 55_crtIbi.TZ0Xg--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Mon, 7 Jun 2021 09:55:21 +0000
Received: by kubenode553.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8e1341abe016182997175c102664b316;
          Mon, 07 Jun 2021 09:55:19 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
From:   Leslie Rhorer <lesrhorer@att.net>
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
 <60A55239.9070009@youngman.org.uk>
 <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
 <d3a8bd2d-378e-fe84-ab81-4ac58f314b50@youngman.org.uk>
 <60de3096-95e8-ca32-3c83-982bf8409167@att.net> <87a6opnnah.fsf@esperi.org.uk>
 <32762416-afa5-e3a0-a888-782a25668803@att.net>
Message-ID: <dd1a85f7-fef9-05f5-a9be-db94d959ab25@att.net>
Date:   Mon, 7 Jun 2021 04:55:16 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <32762416-afa5-e3a0-a888-782a25668803@att.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Christopher,

	What was the outcome?  Were you able to recover your array?
