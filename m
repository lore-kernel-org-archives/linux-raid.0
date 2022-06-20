Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0107CCA47E
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 07:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbiFTH4U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbiFTH4T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 03:56:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D18710565;
        Mon, 20 Jun 2022 00:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655711772;
        bh=6dlAtGOmo3iT0QO4sTYsVspXBmeZRwvlk3clJlr6isg=;
        h=X-UI-Sender-Class:Date:To:References:From:Subject:In-Reply-To;
        b=EkzdaCffJLewLmpbtS9p4TQkf4qY/F+VbZxJB6bJFxilSmoHupbhQ8Q+FZUH0+5GC
         4PaNcXGdV1Azfz3bADcFIxSAhlMrgJZgAiQadXTbp8HaEjr44+K9+SmPXZyH1hxXRw
         UIeMqaFJEvyZyuVHJD6d7T0R+m+73F5JF9UVRhSI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MGhyc-1nqX5V2EOw-00DkSr; Mon, 20
 Jun 2022 09:56:12 +0200
Message-ID: <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
Date:   Mon, 20 Jun 2022 15:56:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: About the md-bitmap behavior
In-Reply-To: <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:92KW57J7jkZgJtxg/4L5TXEQunRHilHHdWC+ksoFcZQIMM5SCp/
 +BbL27Qmtj2YEeIlG5R+IXxiufqn9uDD/xgTpn8lcFd6yVdgT3TcjrR41agYw8a2HDB6FBR
 HblSoMqu7NnmVZPph0BshyCoaAUP7quixCFcb7z3+mPLBUMag9R5iNXuUQsguuDM4IMbajm
 U/jZG8/nN4l9QmiSB1Xgw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qiz8Q26UF20=:bKmB4rg10VKWEh51KfNppW
 QoSJwjoaZGlYctfz0nRMuZghYy1lg70EwSolhBFm+IJmS92+Xw9Xl7vpd4kqMglBDgWSuuRlv
 aOGNmtozsbogkeQb7UrrIserPr0XNdNJv85cI2peLaCfknlhPVdS1lX1MarHHt0Me38uh4cEc
 wh7ppxEz7CySjpiBWaVKZWlLxSBuq7HB2qVC942k78Gfl1glCBYuv9IQGJTKeZPh8WbyjwTKP
 lwJUfc2dpPrVqmcsM2WiSg7cI54ILbXydYDLFjC4wA0Mt/iXTy9VBmQ2mzy4ZS0Axkype3LIz
 vhQ5RvKeXW5jKbbASKeTXaAP2CllEqAaMi7OScrs4gMZiVMbEWIkrRKKqRJek/31m6A6wr2qD
 PTRCfGdSZmpsJ+n+yspmO0nCteJ3vlsAWTUgyt9iIC1IHDbIlhRiyp2jK/G93qc4WBmmROaYs
 vq8hLgeflcyeNkLtelkEXRYjxvU2aD/woocJpW/S+tVlY7oqciVt0VjM7vXb/IYOIZf7DfJPi
 jnWUXwllOx1IFVlTmE9ixHT11O+7IY9xEUAZJsT3f0SZ8WgunbQy6TF4085nY224GrMtZzLCe
 cG9W+hdf9TrKPxtKY4RpTqr9ecCmgUScStjyORGLA5YrPuHsUkqk+ROvUp0FztyHO90AtFx9b
 AYzP+lWlJBnVXE02TfAgOA+eORJTXywIbCMzXMa87QzYd+giry/laOAX7TWe+AbkHVaSjjv8A
 0QBheCYg01LiWTKD0v9Nk0tbUh0dP8oNtsT8IkDmvc2lvy0H0YvD1NFKVzQkI8gTrR5vbbvqE
 W8SgQVUaaJAUnL1YBxtipIE1/+m0oIlrWQsEuamqggRDTxSw8bOEYnQyK9vNnZNHIj2nzVTde
 jcDBaFbuqo+5wKzVAVlA6e48KaDWw0O++c0uJNaew8/0trgxeZUwmqOqBpWFQS8WNgW//dSEG
 dCt2lH+7rZwiBlnuHoZHZ798F3CD3VgWvPrIv1XGa9EYZFPRlbDm1qBE48gRTwe/DFyogcLpv
 GqM/GiFl5s6bDoTxCAG6KLGCthdfwDvnHfFSDWim1S5XtmH18OEXDmpHRkkiQ5HDaR+MvDpLc
 6CDC5Ela8cas6Bs2VIYrnQ6TxAbGV6keI6P16M1egLPM0j9qw1DeS++aw==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/6/20 15:48, Wols Lists wrote:
> On 20/06/2022 08:29, Qu Wenruo wrote:
>> Hi,
>>
>> Recently I'm trying to implement a write-intent bitmap for btrfs to
>> address its write-hole problems for RAID56.
>
> Is there any reason you want a bit-map? Not a journal?

For btrfs, it's a tradeoff here

Bitmap is a little easier, and way less data to writeback.
And since btrfs already has all of its metadata, and quite some of its
data protected by COW (and checksum), a btrfs write-intent bitmap is
enough to close the write-hole already.

Although we may want to implement journal later, mostly to be able to
address combined cases, like powerloss followed by a missing device at
recovery time.

>
> The write-hole has been addressed with journaling already, and this will
> be adding a new and not-needed feature - not saying it wouldn't be nice
> to have, but do we need another way to skin this cat?

I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
completely different thing.

Here I'm just trying to understand how the md-bitmap works, so that I
can do a proper bitmap for btrfs RAID56.

Thanks,
Qu

>
> Cheers,
> Wol
