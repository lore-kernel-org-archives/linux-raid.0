Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B9BC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 07:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbiFTH31 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiFTH30 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 03:29:26 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8EDDED6;
        Mon, 20 Jun 2022 00:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655710163;
        bh=K/Um4X8APrJHVbHbiEkW8yuEcWBatIXLoZvBLIp5PRo=;
        h=X-UI-Sender-Class:Date:To:From:Subject;
        b=k3XMBsLjDX78n6Zz9tunSKltC5lXkYra+bC0hkkOnheWLF55Pnlag7rt6yDsjDZw6
         l1Ic0q4DqGUSR06GxE/ojGCDlWBYsBc6wRI78pCR5E4eFqfMz4ReDKBNIw4p2sGC6L
         +BIm6Is4JS+EJPw7AZ40DoV7SOfP2nLjCVv505i8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MK3W0-1oOiqK1xl8-00LUjx; Mon, 20
 Jun 2022 09:29:23 +0200
Message-ID: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
Date:   Mon, 20 Jun 2022 15:29:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     linux-raid@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: About the md-bitmap behavior
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kaNPtkHOaBVDedGx4uppYXKmB1/0B20Dt7YF1HoUUkb134f0LTt
 2nurl3YTlct2VCA5a3zNJ8Uf8U21R5/1OKDm0y+MilHAy/TVsXoPG3kHqF7mwpc9jakgLAB
 SsBqUS9OQ1MlBLPlZVl7Hdm3UVE29+o2AzPzUFeV07mcj82MC8uR3IBpDY1ehuoFu2Rl2KD
 JPS7ajQRtUa98lR8WEXGQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JAxLYB1q//4=:XOQMXeHqHCdeyocnFhvqgs
 NyrvrkiD/h+sDvDEJGtudMAUesTIoFuW4a3/0TupAdJ5k5mGGpKcW/FEt1csD5hv1dxIJvzhp
 25T43HxD8Nrlm+P0iuhaVZBNiLIg/CSwkefBn5avNAgYhTo5yJyXOqEfN4IJiqi5sfTOaVhXm
 qgUthkOEKqqMz74RJ2Lj1zEVltYQsNw2jqH2jaPxRQM+V1yPruDQWjfBxh1mvTe1Qa5gKGnMT
 wBE3zVbu4QiY85mMuwpYOOj7jGh/8TJjKqdHhcQRtFLpml+NuaBjf1lNC87IbRmDFN+F3z38d
 WInAYlV7W7bVxsONxrXaItLQYKm0W+prMGBCMpfm5GVzefvDOkRM21+/Bt6mHvKIKfOktTGmI
 v0VyygsiXAU062WESysZsmjA078n20gEgUP3ugK7S96zKY91k1cAOqUIgd6Qe8p60GsYLD6sL
 q7CoU9isjch184RxnLoi5ua0OhlHmXKhOu3b5y7QpYPQ69aZbMMNmZG4Ftx6qIYSs8Z2oZrq6
 fxJ60l2clRNVbusGLPfjiQHuZd6DB9tbwdcAil3sslnLVT4gSlVNymL4a8LQJ3oDBUio3tBYp
 OZaHMHWGww5Wmid+ar/FOYmYcq9MOmJ8T5LKZl+DP2E8wcZ2anyFSMY6++SeevkS5AW9FUAbz
 Hath5Nu1QjhR6hMMKvKIYlIJjgSPCzxf6X/fI44Y2D3OeSzNkpApdWXnjR2IuwtML4uITQX7C
 YE9r9+n8uPJvFDA3kQIyYAnzNDkeKohIkDTxRHBW0J6oB3T7tTehDbFV7oe5JXqcR9FsiornT
 ygu2ep5kYGKcA73J9CjZXPjeHIeU3rDXX6BAYWP4ZxYmzw3FMP/zYb5EVittZEfnBfLx3znOQ
 s/dvc7sfnJ0qHJVPf6sZAlqwWpIcPCjH+7fOr/I2/46yjDtihaOeeTe+6CDkqdZ81+HCPp4rx
 7xhyOxEi0NCXB3IgaH8V4SlMsEHZESy+9j8fWf9oj5a+qPyFsr3m8RUCyChCpfb1SKy6JNjkD
 fn8fERng/xXNk+8hwVoSjUdRYWnnxhGYVZRUqjQHbX4IJ0NfSHpBXpD7DhRcxwaHwkX8KAqHR
 P5uFKZmhh1VddhJtbzbVtDDa0PPRXfVwTkzSkk3Dk4NjrYc+sy4oacmnA==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Recently I'm trying to implement a write-intent bitmap for btrfs to
address its write-hole problems for RAID56.

(In theory, btrfs only needs to know where the partial stripe write
doesn't finish properly, and do a mandatory scrub for those stripes
before mount to address it).

My initial assumption for write-intent bitmap is, before any write can
be submitted, corresponding bit(s) must be set in the bitmap, and the
bitmap must be flushed to disk, then the bio can really be submitted.

Thus functions like md_bitmap_startwrite() should not only set the bits,
but also submit and flush the bio. (With some bio plug to optimize).

But to my surprise, md_bitmap_startwrite() really just set the bitmap,
no obvious submit/flush path.


Is my assumption on write-intent bitmap completely wrong, or is there
some special handling for md write-intent bitmap?

Thanks,
Qu
