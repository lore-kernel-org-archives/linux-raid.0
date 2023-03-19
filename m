Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089C7C7618A
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 09:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCSJ5G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 05:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCSJ5F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 05:57:05 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Mar 2023 02:57:01 PDT
Received: from outbound1f.eu.mailhop.org (outbound1f.eu.mailhop.org [52.28.59.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4B423A75
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 02:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679219758; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=GgK1Gb50hj51xhp5+jjfu+eYhBT4EnfRlHAEESzO6IG1GT4bBlrhxysbP98inT4qgU4iYu5Bnq3Td
         T19JLBUVjMdz9OEGdcpslRAwewD6BKKIGlM+IlvFLNTXlZWdtYi1K19bq3YvTs0Dl2/3hWl2Nt85YM
         1fzk75SKATKroaoOaU8hAuyI9fK1BJ1KFv6e2PV17pKSJP/qPfRmmOzqM6EesCaT2ZMbErC+W6aU0Y
         NNDjd6mlW2GpROUrQsi16HleGSrJhuSs4fFFD9kHoNcXrrHjtFb+/c7/GKerGrBle6tsvqWYE8mjsk
         GjfKB7ps72ZOPhSstWIvxZdwCGRTS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:dkim-signature:from;
        bh=c2a93PCyfdhd9XrTJU/Ze9b7RvftofJy60/l2CectgI=;
        b=sYkJaHRSpw5XKe0k9zmFxERycgy7gSGqz6X69c8ILtHacIEcGIKKqWODVD/k2YsTzoz/3+1bru7sX
         q93mM1a0BspUQguN0P7u8IaGm76DXmrx8oEM2QBXIO3MCK09zfDo+P4SGtbjXF3wABsfLjPX2UJbbO
         DCWUdoev8ff4GWTXOFh81xMgDb+QBQnpE8jJxDtY0b0xPGEKKel6Td+To9sLgoLRm8ingn0NvN1Fzp
         9JTe+1P/JaMIlBun2uv9HxLV1M/z9a2lYWa/1Ml9fQQvaJgTYo2h5g7gqGRdH0uTESkWOg6aZNDHAR
         VjyW7B+Gz4z+dKHHCyVK0XoD5yf3neg==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=109.155.212.229;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:from;
        bh=c2a93PCyfdhd9XrTJU/Ze9b7RvftofJy60/l2CectgI=;
        b=P5xL3iBHMOgY0OnjZI5uDzXDllEJDJcFvrMRMxdkJu+x03Mq+klKHAFGGmGctLmAn4hnvSZZKNcwg
         L0Hu24S4+/kqXAzkoC1SnKVpPgE3VuV2NoiZmK1wEOQo5yxJY02m3LGOcDrU9ieiY6oRUwCAYHXg6Z
         iq/gBELBvtBX2VLQdxjIz4nrClNSMuD9A0kOzaeqHrZMdzX+0sTqtH/MTVEhBeGdBbznzuOF0yDE5e
         3VSPvAn9ER1V2hDn3wswWMXTdl/cdtkZQMNI2Q3Y0aDEa8pIh/l4TJmQSWiHQzfucQDVhHe+oVsK/c
         TLfvJyb3Fq/Tr58ybrR6Iw31W01pFQA==
X-Originating-IP: 109.155.212.229
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 3c721abe-c63c-11ed-bc05-4b4748ac966b
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host109-155-212-229.range109-155.btcentralplus.com [109.155.212.229])
        by outbound2.eu.mailhop.org (Halon) with ESMTPA
        id 3c721abe-c63c-11ed-bc05-4b4748ac966b;
        Sun, 19 Mar 2023 09:55:53 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id 2A3081EA090;
        Sun, 19 Mar 2023 09:55:53 +0000 (GMT)
Message-ID: <c0e76e25-8f5a-af1d-cb47-e772ec458176@demonlair.co.uk>
Date:   Sun, 19 Mar 2023 09:55:53 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Question about potential data consistency issues when writes
 failed in mdadm raid1
Content-Language: en-GB
To:     Asaf Levy <asaf@vastdata.com>, John Stoffel <john@stoffel.org>
Cc:     Ronnie Lazar <ronnie.lazar@vastdata.com>,
        linux-raid@vger.kernel.org
References: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
 <25620.54403.944889.209021@quad.stoffel.home>
 <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Asaf,

Yes, in principle there are all sorts of cases where you can perform a
read of newly written data that is not yet on the underlying disk and
hence the possibility of reading the old data following recovery from an
intervening catastrophic event (such as a crash).  This is a fundamental
characteristic of write caching and applies with any storage device and
any write operation where something crashes before the write is complete
- you can get this with a single disk or SSD without having RAID in the
mix at all.

The correct and only way to guarantee that you can never have your
"consistency issue" is to flush the write through to the underlying
devices before reading.  If you explicitly flush the write operation
(which will block until all writes are complete on A, B, M) and the
flush completes successfully, then all reads will be of the new data and
there is no consistency issue.

Your scenario describes a concern for the higher level code, not in the
storage system.  If your application needs to be absolutely certain that
even after a crash you cannot end up reading old data having previously
read new data then it is the responsibility of the application to flush
the writes to the storage before executing the read.  You would also
need to ensure that the application cannot read from the data between
write and flush; there's several different ways to achieve that
(O_DIRECT may be helpful).  Alternatively, you might want to look at
using something other than the disk for your data interchange between
processes.

Regards,

Geoff.

Geoff Back
What if we're all just characters in someone's nightmares?

On 19/03/2023 09:13, Asaf Levy wrote:
> Hi John,
>
> Thank you for your quick response, I'll try to elaborate further.
> What we are trying to understand is if there is a potential race
> between reads and writes when mirroring 2 devices.
> This is unrelated to the fact that the write was not acked.
>
> The scenario is: let's assume we have a reader R and a writer W and 2
> MD devices A and B. A and B are managed under a device M which is
> configured to use A and B as mirrors (RAID 1). Currently, we have some
> data on A and B, let's call it V1.
>
> W issues a write (V2) to the managed device M
> The driver sends the write both to A and B at the same time.
> The write to device A (V2) completes
> R issues a read to M which directs it to A and returns the result (V2).
> Now the driver and device A fail at the same time before the write
> ever gets to device B.
>
> When the driver recovers all it is left with is device B so future
> reads will return older data (V1) than the data that was returned to
> R.
>
> Thanks,
> Asaf
>
> On Fri, Mar 17, 2023 at 10:58 PM John Stoffel <john@stoffel.org> wrote:
>>>>>>> "Ronnie" == Ronnie Lazar <ronnie.lazar@vastdata.com> writes:
>>> I'm trying to understand how mdadm protects against inconsistent data
>>> read in the face of failures that occur while writing to a device that
>>> has raid1.
>> You need to give a better test case, with examples.
>>
>>> Here is the scenario: I have set up raid1 that has 2 mirrors. First
>>> one is on local storage and the second is on remote storage.  The
>>> remote storage mirror is configured with write-mostly.
>> Configuration details?  And what is the remote device?
>>
>>> We have parallel jobs: 1 writing to an area on the device and the
>>> other reading from that area.
>> So you create /dev/md9 and are writing/reading from it, then the
>> system crashes and you lose the local half of the mirror, right?
>>
>>> The write operation writes the data to the first mirror, and at that
>>> point the read operation reads the new data from the first mirror.
>> So how is your write succeeding if it's not written to both halves of
>> the MD device?  You need to give more details and maybe even some
>> example code showing what you're doing here.
>>
>>> Now, before data has been written to the second (remote) mirror a
>>> failure has occurred which caused the first machine to fail, When
>>> the machine comes up, the data is recovered from the second, remote,
>>> mirror.
>> Ah... some more details.  It sounds like you have a system A which is
>> writing to a SITE local remote device as well as a REMOTE site device
>> in the MD mirror, is this correct?
>>
>> Are these iSCSI devices?  FibreChannel?  NBD devices?  More details
>> please.
>>
>>> Now when reading from this area, the users will receive the older
>>> value, even though, in the first read they got the newer value that
>>> was written.
>>> Does mdadm protect against this inconsistency?
>> It shouldn't be returning success on the write until both sides of the
>> mirror are updated.  But we can't really tell until you give more
>> details and an example.
>>
>> I assume you're not building a RAID1 device and then writing to the
>> individual devices behind it's back or something silly like that,
>> right?
>>
>> John
>>

