Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6337EC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 02:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BDBA2080C
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 02:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=verizon.net header.i=@verizon.net header.b="GBE7vlkU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgH1CbN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Aug 2020 22:31:13 -0400
Received: from sonic308-3.consmr.mail.bf2.yahoo.com ([74.6.130.42]:44471 "EHLO
        sonic308-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728015AbgH1CbN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 27 Aug 2020 22:31:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verizon.net; s=a2048; t=1598581872; bh=FNmxsk/kvxtD5FKcylqgTltRyJbkJQToR0hYuXdZaVY=; h=To:From:Subject:Date:References:From:Subject; b=GBE7vlkUqUAtOUzrKzFzW1yKNFFyIwMdonlu/xE9lKTus6w6ESOAFgZP+5PcNKe6ytbsvLn6xll6W3qz5ZgTQAwWgn0Wvfme7BjuM2gFrpEVTaiVnkOF1xJxndKiSb7FyjAWF9y0h2gSxI2E8fC1QyJlVo9xK9EfjDJS6dGQV/3syzuPR5sbVgZ5fvGsa0S6PhkB2H56lptkHjjuyX+cK0D86Y+Tsw1h/VQ5GPnjboQy0Db7kM6aTzH1Tp4ltutAEn2dkmfQ/+DZvckfnvZeqNS/sOCwxx5FukUzIOSsQH7WDewhpeBrncKyPxIMcLzeuhVlyXuMFh+B/ZJLBriRIA==
X-YMail-OSG: PhIsbKEVM1nOoNhLIOr0DH8k2r_TIl9G.JDYcxf5AZYtQc37pwr4cqqD33DMnf9
 u4ZGcfCPeUXp5GbDjygzidMpfezz2bb5gX5v55p1dOwEQR7vB3L17OGekaJu3eEKs05_La5s9OmN
 iTHEsfPg1QxVC4XMyb7R5LKpFAeUxiTpQsAEUnXK6pll.9TsJDFoxOssJo0v08GHheEyCTfGfZ8I
 yhbZ8LRx7U.RUV1D1WlwU1H7F.bNyVNHQmOh_Yi.Sx2JgVp83h_xnvYvdugtd3FLrf2BLmsobF67
 P98rtWJKdGxj7PmybS0pp1Sfa6qso1142JpmLpNz9M3bUKYUBzw65JxNzC9cAG7Y_t2iexJD2bdX
 oL.DiEx_yHmjYLYTRGQL1tPg6VbIVveTakPF3KdiXZtahzNVtHJs2826OSRdaZ2ttumi3yJJY8s9
 OuTGLibK49134mSMo9z3UI68YRuX4Pw.L6ruZIc6Bo8QXERIKxZJQLqstbvXVKAoCHHd7gjy1wz.
 nWYInfv5ipVxuHJcfyzKA6XHWX3P6cpEBqCix_aQ_n8s1yIFYXZeYfyOEPR5BHH7AVh5TXE2Zmu.
 nHSPVHOCfQL.kHuugsMrN10TARuK4CWWY3jRB8UdrO4PqNSqskRjF.1peGfv9cCVRII_NnZg_v1g
 _vHk_JIaUhby2NrA01lXtFoHf9_n69S5SnFteKxE1gCXn_K3BRfaXfCJdcCZiyQJrnbLxHK3xR5I
 l_.TQE6y3NMdcTN0dSd6dJpmonKCgcvX0YNIt0WlneUw_EfzgAt9WA8K.boQ0cd83FBIKO6A106z
 Qx7QZTSmc3rA8bN7Fdcu3y1Z7hXmhfAP0TlKXhG2LqXjv1uHNvzw3YE3Oz3XLAFSHFXqO6qlXsyB
 lkaVyNfg.WnNAmd0ff6vu05jNXYgg8lw0tz2YlidSh4utrNmRn15wHhIiqrE8CAUghgJVvLUyj_9
 qIOsURAGWiAdIRDd13_99kh9txUDARPFAtoqhQmg3tEUr3ItJVQxsKhD6eZH2bmJ54qdRgBUkVh5
 XWgCkzrttjFiQGfjXtqAAdJOvUADz_aytbbvITGfDvUEGkblHFy0IHJ2w34xe0_fos7q_7QXw1t1
 hDmMsi2AmcNp261nL83qkk.mHeiQo9aVkav1KAF.qTPGYVNiBsjzZ_Dzh9fgmgVQKoMYwU8GiV31
 J5RRxmX0iYu0aXfw6B8ZfZnp0LOM.pP0jnES3X39Wlhdss7ymoMwZub62fBuMLFdHkCphFMZfjsF
 8xLwtcbFb.XEczl7TkbwR_zDYfT.qKSQ08sQZm7sfEakYb_vaFHqavd50Ve0gAPMH1A.e7EV4x3Y
 Mc4EvFFMsBc3b9Mb4EgAuk1DIGCQfbmH8FgtrSDEMju5MQJxTEFUBdMz3J3Vy7JXAwEMAHkCeX7I
 yAD9U8OYj5LrHW4dvzyDX1XSXDwDLh4DtvcY3jGaBZ.99ze9kxy9WZ9WqCl.f7YyciN4Z1U2Pgw0
 GYYHh2AIElRC.tTGIL8nw8H_wkrySfxO8GPDwoSq9NgoS7BAcvfaExdZg3j5VOG4DCBYtOHq62vc
 .Dfsl36s82QFtqj_c8cLi3AxBCWKq
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Fri, 28 Aug 2020 02:31:12 +0000
Received: by smtp418.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 86f886d190c32ac1daf9ab538ab58e51;
          Fri, 28 Aug 2020 02:31:08 +0000 (UTC)
To:     Linux Raid <linux-raid@vger.kernel.org>
From:   "R. Ramesh" <rramesh@verizon.net>
Subject: Best way to add caching to a new raid setup.
Message-ID: <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
Date:   Thu, 27 Aug 2020 21:31:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
X-Mailer: WebService/1.1.16455 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have two raid6s running on mythbuntu 14.04. The are built on 6 
enterprise drives. So, no hd issues as of now. Still, I plan to upgrade 
as it has been a while and the size of the hard drives have become 
significantly larger (a indication that my disks may be older) I want to 
build new raid using the 16/14tb drives. Since I am building new raid, I 
thought I could explore caching options. I see a mention of LVM cache 
and few other bcache/xyzcache etc.

Is anyone of them better than other or no cache is safer. Since I 
switched over to NVME boot drives, I have quite a few SATA SSDs lying 
around that I can put to good use, if I cache using them.

I will move to xubuntu 20.04 as part of this upgrade. So, hopefully, I 
will have recent versions of kernel, mdadm and fstools. With these I 
should be able to make full use of current features, if any is needed 
for caching support.

Please let me know your expert opinion.

Thanks
Ramesh

