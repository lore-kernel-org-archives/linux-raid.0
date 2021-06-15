Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F91BC2B9F4
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 02:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7FF361059
	for <linux-raid@archiver.kernel.org>; Tue, 15 Jun 2021 02:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFOCeO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:34:14 -0400
Received: from sonic315-10.consmr.mail.gq1.yahoo.com ([98.137.65.34]:37308
        "EHLO sonic315-10.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230155AbhFOCeI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Jun 2021 22:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1623724324; bh=yRP6wppKoImKnTzrS2SUZtPVIWNUSwzjTxIonnR+19k=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=Co1fdLe+MuhXsfjQTTbJoEpDZU+SshRXFl0F5BfCPFTGilYpdalM/Lb2JYGHxW1yKiMNnBObsOe07hVT7LkSIXWjY50jKDWRg4WuLTJE1KebhVt71fLqtNTxCpgTMgkMMCTsU5hV88tJx5Wt3VoRUwZLRBTV12t+PZvGrDZMReo=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623724324; bh=JZHWg10dtbe4gWu2Tbto+lwCktvi9hoi7fcaBGZLIGX=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=o1DRh9gqhUNLsSS+A/i0z1BWeVhLZSSUTZ5yoOGSqmTS6DCmi9AZZzJibs/FtV3xmcvZPvC4NJNOt+RRNCDXIV/jRSvg1TEY9FDzgBpbWz0BOYsksTEbQYAe9pFEPLmHKh04QuvrR3k+mWrtu06YmJyKRwdZrmpUYgyQj35vU9T/Bmi8QaP/rGrXaUEmY2Iraev3nNRnVx44GAluS8CDZ9/csPeKvIze5By+h0w90o3kWda68Se3byhVTqPrjOjqiYY86rd7HpjZ2Wg/KnUQrD0Gy6tY5NhiWXhuLopoOhAp0ST9AlOzLU7UjI8h/jjMKNq99/U3EEaTXI7JsdHVuA==
X-YMail-OSG: EUTMDIEVM1kC6F9imPJFrLtyprEIqv.DrewbZst02YXC_yN69fPyq7b2TpoyqCK
 6AgVmQ7z73ERkjPbjysgyjQsWVjJKNqIHKdyj0AxCB1Hj1gL.3ykHK3EA9ijs__IHYWNXiPfkrrT
 yT.ZW2OSiPsqrc37H5XKJ3JnLUoHDWWcSndTkgn4Y5FvJVboK.9_CXOIjkNpu2JGW7qphd3pNtnJ
 AZ5vz3SPl5zXj7bT38BVtoMHjPnZNOxqgbMToIxM42JDhrkxXY.vVErtCwrbZjO92NP0xMXhFXW5
 t2PtrUm4HHs8dlHq471Vh6X1hsmMruAocR.xVrUQGkq6xMrZQftLGivklKeMy_4wuCIywM9OQiSU
 5uplvtd_8NBg2dAa0_.cTySZvoUM_9iotcafkVmeaPdJkYYp4QzCvcwVpb92TukL7kr287fBWB5i
 ulxkoXNWgrbbhg3Pqjj6mMJSSW25xjRcOLHcAytOvz44biPb8WntgDdzB6EqFB2CGb.sYPmfLnr8
 9jkLRKJTvzAWseamk_e0Huh52e6_P7u_U0Zb6cFfLhwirZ75ByE9ceh7milcsnGwsrChxwyYPh_s
 OXc0utTtaPHLcfDCkF1pNzVvMVWvmQleqYVLrkVa6ZJLVjgmm3NGcA96mTpIsM_rHpzZ770AIMiy
 I40Ue0LjBjwv_MilmFuDbuDsZVdLcAUCmPbQQYjsljA3CIZXQsl2YFaE526tJqyWWb2XVtrSeKZi
 j5leO0MvHxJmcAqcUcf.27dcz9midyPu9jJPyawnlJzZg.Twg7.OOO4nh6Wjj_Q8IAbaXxXn9wLr
 Jm5jbvalSVRAbDRiqZ0Kf8mO4sxR2U2o8wb9OgNyp.M3D3yx30hkasDPTE9OWqLNhTyCajVoDZg2
 miL8DUCYOjQRRLer07Gh9uNab_js._PhAArr5bdxgYaJWajqdhJ13WIZf0dgyD6ZkQk2qmHed6cT
 DbplduAvIUsr9sQhMy_.0_g4fLg40I381sOv8aeRymU5_ysfLa4._PENC456B2RrD1ZKSpnv3qHV
 CfhrWCiWhvgQgbT3zsy0KpoefPBdriKtF4JGecP1HyjPiyDPstJoAg6bvYN9mDwElFSR5s4f28Go
 XYci4_rl4MGz5DDPCkHDewnO1DwxEozWsbQx3ZzRMm_P.YPBAbnsZaKlLJgXh1O7DzQlPcdFiG2e
 jKt9TrfKRbGx1IsL4QrrOURXpf5oeCZZ4vFTDvZrvVuvXHIOaTc53whRE2AnYCg8q5OA21reU.Oa
 qFYOHSSp_evboUPoCGTv5h78onQNp_vxZMBnONZKJ_udc8NyBOoGuY22FVsv7pgbRaXezFF7p1tg
 Zufg115DB5I6LVCy50A1Ht5X1p82kMXdxuUIcWttHlJskeWbs1Db55Krvd1fLvQoXwe8IHr5h53H
 G0ZjMZTPSo1yfwBRiiWtUobtGRauTwvSnNdbhf9G9hFuel8pOR63YJBfZKLSnEuwZ1HAV4h8Gaok
 .YgX6YEQhwc8N7ngpCqtbLPyNogAkN4qrYHcgLLFQvI0SMMNGkRjA9caZIqHe0wnYzLqN9UuvnHD
 pc_9nmU3hbxnbBEsnFtMcFbqKiTqAHvS4bQPDiH0s1wEJnXDgdYeNKY03.eLTxY1g.hA3rA6xzDE
 Z7Hg2Qf5Tq.1rtlzq9Mb4vP5PrezMbuvnrUSNL.NiApvSIqYeiRhEEDtYprtSV0MQNgI9Ckp3Agc
 X8hF4rIX7vDzlyra9vfq0UCcNv1_G3qnKGp6L_PzVrymrBrbKTp2lCAYr_JlNHO65Tll9ThEe_5H
 yxP0ZmRUrXux6IsE7zsQ9qpHsq6Z3UQr413dfoy_Yw3dQ67TSlV6c5tB08fStCn7Mt9VIKYCT0ik
 VoqFCNBYaSoMDmlOklcezyprRjPUHMHcwVX.7TYtK14E9JpF9NXiPhyhNVmp3xkj9BOkl2OZ.MNe
 qDM.Al0UB_muLdvR68GUAmeK8pOR_8kWDBJwifx8nxrH5cB1QSoKHEZw7IvyAAz5gr4JuZ_PO2qa
 ZywNV.CGuWfmzDoP0pp4qamYl99bD82FM0CIC0poxZ52WZwODw0LhbiA2SDjAUyINpwVCeaUtyJy
 7dK7f.6fWbHnLOLD4IV.TfDtV9VVkAf2z7egwFxMOxU.imhR3OaQxFGbXKl7JmilLqL0XwhgFvA4
 XCjvS0mi5adITY_sCiH3iX.kiNVgcAl5aaxhfG3Z9UJP0.UrPRmuIFZe2zRuN5TS7ilNyVI5PDqX
 S_z4eG6U13TkCnuT.cNZL3MBt_CTnVGVey.3DhXxFveriXVTz3aQT8Eu5.vxLG5GKQYyPEYWjcLA
 LhBm7PK6J0vDvqEtMrzBCIAsGqfMrzwOatBtEiaoY0_94LjDW6aMUU1y3HbXZG08_A7rQJ3gbeav
 9hmqLLyNKAnefz6_e6AsNs7wMkODAuOtylFzfCn8c9RXQJV4rh5omzyiFMiYBNQhiK4aLLzhVqHf
 TzK1MHg--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Tue, 15 Jun 2021 02:32:04 +0000
Received: by kubenode541.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 60eb6c6571ec9623e735b3c0f1cd11ea;
          Tue, 15 Jun 2021 01:36:26 +0000 (UTC)
Subject: Re: Recover from crash in RAID6 due to hardware failure
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <bd617822-79bd-ce40-f50e-21d482570324@gmail.com>
 <4745ddd9-291b-00c7-8678-cac14905c188@att.net>
 <ed21aa89-e6a1-651d-cc23-9f4c72cf63e0@gmail.com>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <f07a1c5e-b2ed-cff6-e4e3-1f4956a68c3d@att.net>
Date:   Mon, 14 Jun 2021 20:36:22 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ed21aa89-e6a1-651d-cc23-9f4c72cf63e0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18469 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Oops!  'Sorry.  That should be:

mdadm -S /dev/md2
mdadm -C -f -e 1.2 -n 5 -c 64K --level=6 -p left-symmetric /dev/md2 
/dev/sda3 /dev/sdb3 /dev/sdc3 /dev/sdd3 /dev/sde3


	You only have five disks, not six.

