Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3475CC6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 12:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCSMqd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCSMqc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 08:46:32 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Mar 2023 05:46:30 PDT
Received: from outbound1a.eu.mailhop.org (outbound1a.eu.mailhop.org [52.58.109.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60EF4ED7
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 05:46:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679229927; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=O2JWL5odrEnNDcnhRIdJIaC8H7cio6kz4wNynMth0blyQfqqJV5vYPQm63JrYG1Z61/hs5aGE9VG0
         hW3NoJWVT1zIFMBqNIKR5qs+LB1HS0PaP0cjdWbRKlt2f8oVEtUJoV2xwCx2F0sp3TXIgGjpw2UNJo
         djZpSme6SqPKTZVphwBt1vwuS+F4MgXwBBKVdf5C5sQKInmUt8r3+SpIR69L2XQWEkayLSwoGOOXRv
         C8Nq3eQ7k4cIWaVrPiXPRhar/xgIGwnKYprzl5LFX0md9+I1QqYB21c8/kbTvZGLNBjKvPemAIFtoh
         ltS5POMilSysjC0bg+oRomCF4FHwPvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:dkim-signature:from;
        bh=5Acf1jrNV9J6UVxPixauQm7ubMQDIw/sZh+oJfftZV0=;
        b=mF7Tin1iuOXnFjICzUiUjzThpE1Deb6ig9sEaYe0VF6Fg03hBjlbw0/18h4TDFiqcLCp7g7Ht4bXs
         6xteiuIr4rDCawt6Tw0kZUIFAzNFxK+0kd66PA4bRNsG3DIX/madcYode4DIL21cOwoRbfATo6uhCH
         jiP1iFoID1EX8ieS/X1GMR2YudplAeAyV/qHTU2aPfOQXFpBpb2S47kWwGdHjgCLkutOzpo5OQRWwr
         qC4F85zRmPbH6OBRd04IueZ5VSi6/baoOfHUADQmyOllWn7gX9JEUOZoCfvvTYR/hX7ORdpcfy96uU
         aGa9GbYOuJaAgHA+9x6RYzDGL/HyUKA==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=109.155.212.229;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:from;
        bh=5Acf1jrNV9J6UVxPixauQm7ubMQDIw/sZh+oJfftZV0=;
        b=lUilzIjuIr46feQnqmcQH3N8fc+oHFD5iEmiluGwP+L+CZjq7LWjn+8+OqyCB6ui16mW4FtCC5auz
         zzQ6X7HeFF+TC9kjP9IlXV1/q3o0wgZgo7g4xyuU9EWVJiqJYRx6SySrpVEFI8qGV6s9Yni5FNEK8G
         ufINhr/f+JNmXjoigCIXRtLhS6625mS3eTpjHacUS9u/fGwICrUxd+PKEKKPvSMhnjCRJPW+PQfRU0
         k4b/z7IOUyU9Z2wbqsuPK7Bm0BXNx3JNJHT9Hmd8nOMnwS2iImUzeFGbs6S8gH9dCpso9MD5tmmbgR
         wKLt1GuP9F1C36QIZTCnKVeq+mRWXrg==
X-Originating-IP: 109.155.212.229
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: e9f3fb6d-c653-11ed-bc05-4b4748ac966b
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host109-155-212-229.range109-155.btcentralplus.com [109.155.212.229])
        by outbound2.eu.mailhop.org (Halon) with ESMTPA
        id e9f3fb6d-c653-11ed-bc05-4b4748ac966b;
        Sun, 19 Mar 2023 12:45:23 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id AB24E1EA090;
        Sun, 19 Mar 2023 12:45:22 +0000 (GMT)
Message-ID: <c9a0489a-32a7-1fa2-cca5-3c2f03106593@demonlair.co.uk>
Date:   Sun, 19 Mar 2023 12:45:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Question about potential data consistency issues when writes
 failed in mdadm raid1
Content-Language: en-GB
To:     Asaf Levy <asaf@vastdata.com>
Cc:     John Stoffel <john@stoffel.org>,
        Ronnie Lazar <ronnie.lazar@vastdata.com>,
        linux-raid@vger.kernel.org
References: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
 <25620.54403.944889.209021@quad.stoffel.home>
 <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
 <c0e76e25-8f5a-af1d-cb47-e772ec458176@demonlair.co.uk>
 <CAHh8SWFzXx4f-vzOsuPVZAaNMH_RKufHB99B=vMFYZc+s9=msg@mail.gmail.com>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <CAHh8SWFzXx4f-vzOsuPVZAaNMH_RKufHB99B=vMFYZc+s9=msg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Asaf,

All disk subsystems are inherently consistent in the normal meaning of
the term under normal circumstances.

An application that requires your specific definition of consistency
across catastrophic failure cases in the disk subsystem needs to use an
application-appropriate method of ensuring writes are flushed before
reading.  Writing with O_DIRECT is one method and depending on the
application's exact requirements may be sufficient on its own.  In other
application domains, flushing and some form of out-of-band signalling or
locking is better.  It really depends on the application.

Regards,

Geoff.

Geoff Back
What if we're all just characters in someone's nightmares?

On 19/03/2023 11:31, Asaf Levy wrote:
> Thank you for the clarification.
>
> To make sure I fully understand.
> An application that requires consistency should use O_DIRECT and
> enforce an R/W lock on top of the mirrored device?
>
> Asaf
>
> On Sun, Mar 19, 2023 at 11:55 AM Geoff Back <geoff@demonlair.co.uk> wrote:
>> Hi Asaf,
>>
>> Yes, in principle there are all sorts of cases where you can perform a
>> read of newly written data that is not yet on the underlying disk and
>> hence the possibility of reading the old data following recovery from an
>> intervening catastrophic event (such as a crash).  This is a fundamental
>> characteristic of write caching and applies with any storage device and
>> any write operation where something crashes before the write is complete
>> - you can get this with a single disk or SSD without having RAID in the
>> mix at all.
>>
>> The correct and only way to guarantee that you can never have your
>> "consistency issue" is to flush the write through to the underlying
>> devices before reading.  If you explicitly flush the write operation
>> (which will block until all writes are complete on A, B, M) and the
>> flush completes successfully, then all reads will be of the new data and
>> there is no consistency issue.
>>
>> Your scenario describes a concern for the higher level code, not in the
>> storage system.  If your application needs to be absolutely certain that
>> even after a crash you cannot end up reading old data having previously
>> read new data then it is the responsibility of the application to flush
>> the writes to the storage before executing the read.  You would also
>> need to ensure that the application cannot read from the data between
>> write and flush; there's several different ways to achieve that
>> (O_DIRECT may be helpful).  Alternatively, you might want to look at
>> using something other than the disk for your data interchange between
>> processes.
>>
>> Regards,
>>
>> Geoff.
>>
>> Geoff Back
>> What if we're all just characters in someone's nightmares?
>>
>> On 19/03/2023 09:13, Asaf Levy wrote:
>>> Hi John,
>>>
>>> Thank you for your quick response, I'll try to elaborate further.
>>> What we are trying to understand is if there is a potential race
>>> between reads and writes when mirroring 2 devices.
>>> This is unrelated to the fact that the write was not acked.
>>>
>>> The scenario is: let's assume we have a reader R and a writer W and 2
>>> MD devices A and B. A and B are managed under a device M which is
>>> configured to use A and B as mirrors (RAID 1). Currently, we have some
>>> data on A and B, let's call it V1.
>>>
>>> W issues a write (V2) to the managed device M
>>> The driver sends the write both to A and B at the same time.
>>> The write to device A (V2) completes
>>> R issues a read to M which directs it to A and returns the result (V2).
>>> Now the driver and device A fail at the same time before the write
>>> ever gets to device B.
>>>
>>> When the driver recovers all it is left with is device B so future
>>> reads will return older data (V1) than the data that was returned to
>>> R.
>>>
>>> Thanks,
>>> Asaf
>>>
>>> On Fri, Mar 17, 2023 at 10:58 PM John Stoffel <john@stoffel.org> wrote:
>>>>>>>>> "Ronnie" == Ronnie Lazar <ronnie.lazar@vastdata.com> writes:
>>>>> I'm trying to understand how mdadm protects against inconsistent data
>>>>> read in the face of failures that occur while writing to a device that
>>>>> has raid1.
>>>> You need to give a better test case, with examples.
>>>>
>>>>> Here is the scenario: I have set up raid1 that has 2 mirrors. First
>>>>> one is on local storage and the second is on remote storage.  The
>>>>> remote storage mirror is configured with write-mostly.
>>>> Configuration details?  And what is the remote device?
>>>>
>>>>> We have parallel jobs: 1 writing to an area on the device and the
>>>>> other reading from that area.
>>>> So you create /dev/md9 and are writing/reading from it, then the
>>>> system crashes and you lose the local half of the mirror, right?
>>>>
>>>>> The write operation writes the data to the first mirror, and at that
>>>>> point the read operation reads the new data from the first mirror.
>>>> So how is your write succeeding if it's not written to both halves of
>>>> the MD device?  You need to give more details and maybe even some
>>>> example code showing what you're doing here.
>>>>
>>>>> Now, before data has been written to the second (remote) mirror a
>>>>> failure has occurred which caused the first machine to fail, When
>>>>> the machine comes up, the data is recovered from the second, remote,
>>>>> mirror.
>>>> Ah... some more details.  It sounds like you have a system A which is
>>>> writing to a SITE local remote device as well as a REMOTE site device
>>>> in the MD mirror, is this correct?
>>>>
>>>> Are these iSCSI devices?  FibreChannel?  NBD devices?  More details
>>>> please.
>>>>
>>>>> Now when reading from this area, the users will receive the older
>>>>> value, even though, in the first read they got the newer value that
>>>>> was written.
>>>>> Does mdadm protect against this inconsistency?
>>>> It shouldn't be returning success on the write until both sides of the
>>>> mirror are updated.  But we can't really tell until you give more
>>>> details and an example.
>>>>
>>>> I assume you're not building a RAID1 device and then writing to the
>>>> individual devices behind it's back or something silly like that,
>>>> right?
>>>>
>>>> John
>>>>

