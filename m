Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCEFC47082
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 09:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 736E76115B
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 09:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFGJyt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:54:49 -0400
Received: from sonic316-11.consmr.mail.gq1.yahoo.com ([98.137.69.35]:41028
        "EHLO sonic316-11.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhFGJys (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Jun 2021 05:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1623059577; bh=M1Pwzhqh3YN1qZy1RzaONM/WARibGhuVgAd9w+5Wssc=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=46XbCuOS5OwgdbQGlArsd9ftMAlk6ayZvOETLOtwBAkg3DeZdEsnlf2mQSGV7+YtiyaK5yNn33HI0/c4BhDe2DXh81CAJMQJEzhad6xiJeJReELfjABTuEz8hxf3Yr6DfEDXDjLmpfhr2FWsgERzVLZdCgqr7tCjVzK7XzkM1/Y=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623059577; bh=m40gu0V74sINV/39IQsUYOP4H5zhGicN36TI7Acd6fm=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=VMu+QXYFGMar0ZEQfVUnv9QwXkqSjrCDVmlCICofU67aoRlwzumNtH+Vt+9I5bOTOsDY4K0t0ng9vh8yeh/HW0vbI8xBoPHdA93gFTzoarM94HumNj7KC9i1E4QDIejlMvAVjAnWh7LidTS4cl0sTdjscjo3gBZUS1D7yWgH9EYio6oiftmU7CylfWBMnGWolIkTT7Kg3uBPiZ4PyfkSI3wbO34jgjzsGOpagNa8OcRVwsm1hxQ438W3WP9E4uUQtXfucrCGDsPrbOdQ42INKi4QLOerUuqALw5Z+GfB3d1+F1FCrjQ0IEPuJZAPZ6l9sSiC1umeGsllcpiusYEasA==
X-YMail-OSG: AHK3qWgVM1mAny2AXnTphZauMtWgVSp08.lBNUVOto28O0qmIRjT9vfATKVxsQ5
 3nOk6uLI4THHEQXqD7Sh_g9wxjoTW9p7vT9G_7FAv7gkQdn8hidqwGLf5uL71SuzuklZldzchpfN
 MgJg8Hlp7L6g8f605JHdWgAKdh3FH2cBHGsjj.q.0LurCPl3rOTLdVY9573LVF38Q9VkOqTJnuDt
 .hxEmBnPqAr4XOCqO4eopbCwbkFLSyyi6wwWoDeN0WQiauTrShasbSPFFsre6BeKIMXXW9PzXmMv
 OwA7Hxipi_m6dRByf.s3ZfY4oaDsv0NmKKE6KgLQoek2UY.iDxZJWF73NK0M8ZHcQpKBUrBDMlUL
 6x76XN9RMsf5ehFmLfUf6ehxj37PBEQlUk2O69XFg6Egfy8LmzQ6.JxsG_WDJd0b7Sxuvkh6eoJR
 .KCsuMwlUJqNudvmpjH86lXLX8_6jwWitqB_.t3_lPNczvIesC21iFhcEENOjs7N6S4qgL7dUjC4
 LLvheptGab3B4eAWyHPJaPVfNyHyiDBCFFIofNYzlq2rJ1s82yEdy27tkk8OWPzhPvj0SkY6d5mt
 JX0VVNdSH7ohBGQ0iOp98NaW35P41dNUSSfozRfD1rAjpSrvlUahJ5Gid74_1yplZn6ty83dueYJ
 T15XmORk2RNHSPHZPpWCZMgStaFeYkTDA0lh0uT3Tf5L3pK21aOpqkuh24BoIKsHv.5DzyqatmF_
 7xK7tjLf4pmoJzBG4WhJA_P.W0F3As4AySKcIIp.EZEOfqOxZxfkIU4Oz1nRn.NEBLlNLIEeEffo
 ZFpw_.AkRtvNFAAJyy_w_gqf9JyyOF.GWmyiqu2wypMG4_IjkoS_mOwz2_f7VnFrpV_ytcpfTEr2
 47BUD6d57.LhoWCZJzgeMwJYKF15T2csa9W4TKnB8S1ERrTo040h_.J_YL8sTZKA5a0wjsfDTtxB
 29zW49FSZwroincFEpvx3sfHeyYSrf5rgqSCiTSm5NQmAlpnyRgN5SxGdwxLTEni3iEJw0CP0m36
 mCoICSmaLe0Pze.hsfHVJAIiMqVlqTLwoSJJk.AgUk.AKcnFeXfQRX7ErtEP5VSJP_97TkdcKs4I
 JeHoIeZLQD.tAIiznr5cGo9APjOr.U77GGyRGMf5IF4u4XaOTRiBktkWLNRvMbQIyAgtDDxINq8u
 clQNo_fnQVq.1uhdLuj_dZpwtXvuwgzwbN.IbF17cC6n8hqyL2.WLTOD7QCSaq5HEkuwCuc2wVld
 KN0e.baf4rfbBC6SwfHqvzNBrujz6trmZVcoGiORF203n_LB9WrF5zX8bsgVOQcqFZdI_eEdlIx_
 rzG7yAVvUK60PhJElmVaCzC30ws037Rb8SVQWZFm0MwzedOzzJClweteUtdZwmLlfyjFLCo5UVop
 yPHYU57F_Sjg98YK_4w5UDFVl8nIdqUPmpZlpDpFbOE90f8Xr69OuUiTjwy39qMee_sSdAQ3zAQr
 sY2JjNrBcTrJRiNeJLBQc33daYdIDj6v7aEioweU6iz5QYW_NmyDNTRCeAZmeFBOgsFYtp1ov5j0
 nyVC6JDUtAF5Q7zfnLowsRmQtUTCRcsRTEPHtxtcP7UKFLtynjfU.z6e8db_l7QvOVIQFdGLu6na
 iw_wA.iZVouyCsxpqe9JOWbSJyZ8Tv44fFAyvL3DJYu109UfDGV.EdvTr4xDAPMjRHQPGTF33HuZ
 pXR3vbd7ozwRiArhwKq3jrpU.KZIqhzhD.q7IJQ4t96z91U9JQECoW00bvvDX_SVa1KqqVsx7SlM
 WoXmOe_af70BKNPrnknSokxM8RRBHb0ikVKhi3chVWKiksF1QGj90UthYnZCmjGI9h3HRZu4oq0O
 w57E8csWKEj3SQlPzq4INNekX0ELZ_9t8GTY1VoDuQ89FPhxhMPAB5WFlCY8mFGx_wavStYcHJuz
 TqMnPlr0NDyeHEQ0HugpVNvI95feciX0l35gb90.HcYQuxzXnWMVV4MLiHnNGpW5xDgGDeHSNtdd
 LldhVZu4.M9.ltoQxNVHElpkx0R4h9Lt4dIZuO5CdBXPTQ9c2swkNsIUMT8sl4ZDqzGSMZdvGw20
 H5YcXTK6JRqxmYTZKztvzLZeBkjHNBaTlR.e7RnKYIxTEZVBkpAhQMS55uJY4RBXN8I9826nN3LB
 e_PV474R9EGqjgi9Phioajknta1PlHPRqrUBpHyNOKXZnaFcjGtST0dxaRNfUFrf2i0.GoOcbzYv
 qSIkJZ3WzPEyvZJ2U_Z2GorFNuqcbqVe69KHwLjWWUyv3AfH2V9ql72GNKSOkuCtiI4oggwJ8GJg
 qu3lwdc8pv5Rs3qm35iQ4yZXjCum1M.hwBxRRusk2NjZPHUSPyzkvXoF.Hfl23eUiyBxC5uDkIbp
 QuQo1oIZ0AfGWuLOPzq8w0kibo9KYjhABMPE-
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Mon, 7 Jun 2021 09:52:57 +0000
Received: by kubenode544.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID b5746f2bd77a943364cef2623f3286ee;
          Mon, 07 Jun 2021 09:52:55 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
 <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
 <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
 <e4258686-7673-9f5f-d333-fbbb95c066b1@turmel.org>
 <87lf89nqly.fsf@esperi.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <d1da9041-9005-dc4e-2cc7-05e962bb8fcf@att.net>
Date:   Mon, 7 Jun 2021 04:52:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87lf89nqly.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/20/2021 2:37 PM, Nix wrote:
> On 19 May 2021, Phil Turmel spake thusly:
> 
>> weekly scrubs
> 
> *Weekly*? Scrubbing my arrays takes three or four days. If I ran them
> weekly the machine would never have time to do anything else!

	Three or four days?  How large are your arrays?  I have quite a few 
arrays up to 48T (64T of spindles), and none of them take more than 12 
hours to scrub.

> If the storage machinery on this system is so badly off that it's
> misreading bits more often than that I think I have bigger problems.

	That might be the case already.
