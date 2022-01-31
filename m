Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37241C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 20:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240122AbiAaUuR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 15:50:17 -0500
Received: from outbound5h.eu.mailhop.org ([18.156.94.234]:14440 "EHLO
        outbound5h.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiAaUuO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jan 2022 15:50:14 -0500
X-Greylist: delayed 2764 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2022 15:50:13 EST
ARC-Seal: i=1; a=rsa-sha256; t=1643659448; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=EsF8nGp9HmpapxFWV2CCpmmRjoOzUg473FdgGr9I+0MJ8nuuDkfAxrVzrbya0fS2IZ8q//pao2KVy
         GL2inRR1X1IRomlyZXt32S+euizkpCpewDOfTQJrr2+UqDoi/yUay2rNgJr7DnMKEr1fMucJcTHA/s
         wPC5eTu8o2nxaAWxu3/tnNhWhXomzFnJzkIv1NskgpcSAdx6x/cR57XPXzIREeC8DxOeC/Fq98aa9d
         no1sE+WAukIR9moORBZGITVa6oLgFokBR3XgyC5+mIpeiRmekqCTfkHcFQDFWK0R1m0Gy5yEfn7j11
         QSFYlJnbfC35IxXwspRYYneQXGZIpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:dkim-signature:from;
        bh=kxLStytX1XepaluXBTgqoPbxu2VD629N1gexO2wwKhw=;
        b=ePt/sWOCu42mgeb5rJKuq6Htk6lmcBRDacxYYUy83GKdCqPxiNT7MDooitfQBCqX2ZBEhZfrFo32X
         JEAChe1PTXebjg63ZIAQXftE5xeBLgcCWR8ISxUVhywzSk3GCEArIoJJBRXt9kvMeQvoR4VFYGkmIF
         k+pvFpg5fUpBGroO5bm936O1jCV6KWWJjry+4hiwcH+a0AJkkdtN7ukW6astgk7fK6Neu+y4d4ePLo
         px3Vt1GPVMSGpMSqc1Ush9i6ULOdxU59pL7ML/4RUuzhxi7c+DP0VLU+W9bm/pm3KGHLr8LdRTwY/T
         Owo7yu9cj92l1Pli0wLTuLkBGz+nv9Q==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=86.166.202.46;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
         subject:mime-version:date:message-id:from;
        bh=kxLStytX1XepaluXBTgqoPbxu2VD629N1gexO2wwKhw=;
        b=k15UUyT+qi/usjuwzwOmCdYtA1kj6K42sskxeivWFtG8Tkr2g29iHV97UOY1mhCcEYIJCVn62ZoI2
         nRrQwAhKne2D9XzTv0HkbECivgeDsAaA/BA7JJ9CLhA079wG6xrubp7YOYQgG+QLl1MKUoPhoF0mwZ
         gdsRKImgao2cBQkz94bC9pOsqUNAifyw4V33KwR1PbGiv86ZtPFlTxqBa/2/92gJUxbD7iODFgTqvZ
         NEMZTYLlMJdwQzkFWbZPT/XDpgKNvPW0D/l/PHrrvbq/UYJANFWfkKFnSMHLIlfNOjNy1NUASLXMPP
         qKE+f9K2Pjjl0rCVBljbAXv1wsx5MSA==
X-Originating-IP: 86.166.202.46
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: ef39ee56-82d0-11ec-a079-973b52397bcb
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host86-166-202-46.range86-166.btcentralplus.com [86.166.202.46])
        by outbound2.eu.mailhop.org (Halon) with ESMTPA
        id ef39ee56-82d0-11ec-a079-973b52397bcb;
        Mon, 31 Jan 2022 20:04:04 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id CD5EE1EA0B9;
        Mon, 31 Jan 2022 20:04:01 +0000 (GMT)
Message-ID: <5f059744-9668-6ba2-96f9-6a93eabde473@demonlair.co.uk>
Date:   Mon, 31 Jan 2022 20:04:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: hardware recovery and RAID5 services
Content-Language: en-GB
To:     Phil Turmel <philip@turmel.org>,
        Roger Heflin <rogerheflin@gmail.com>, Nix <nix@esperi.org.uk>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220121164804.GE14596@justpickone.org>
 <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk>
 <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
 <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
 <c3b7a580-952f-7c7a-fddc-88ca0b5fde84@youngman.org.uk>
 <87leyvvrqp.fsf@esperi.org.uk>
 <CAAMCDee0zoWB9ud6wxvfSj0rpswFde9dd2T3chur4R9YFnRPwQ@mail.gmail.com>
 <d4036e94-4df8-c068-c72c-926d910c63b4@demonlair.co.uk>
 <698869e2-b45c-a355-f58b-d7b1b4f7830d@turmel.org>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <698869e2-b45c-a355-f58b-d7b1b4f7830d@turmel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 31/01/2022 19:21, Phil Turmel wrote:
> On 1/31/22 14:07, Geoff Back wrote:
>
>> If a disk has one or more bad sectors, surely the only logical action is
>> to schedule it for replacement as soon as a new one can be obtained; and
>> if it's still in warranty, send it back.  If the data is valuable enough
>> to warrant use of RAID (along with, presumably, appropriate backups)
>> surely it is too valuable to risk continuing to use a known faulty disk?
>>
>> In which case, I would suggest that dangerous experiments that try to
>> force the disk to reallocate the block are arguably pointless.
>>
>> Just my opinion, but one that has served me well so far.
>>
>> Regards,
>>
>> Geoff.
> I would be surprised if you got warranty replacement just for a few 
> re-allocated sectors.  The sheer quantity of sectors in modern drives 
> and the tiny magnetic domains involved means **no** drive is error-free. 
>   Just most defects are identified and mapped out before shipping. 
> Reallocations cover the marginal cases.
>
> I replace drives when re-allocations hit double digits, though I've had 
> to run a few corners cases well past that point.
>
> Phil

I've never had a problem with any manufacturer replacing a drive that
reallocates even one sector within 12 months.  I just send them a
"smartctl -x" log.
I can't remember the last time I had a drive do its first sector
reallocate after 12 months but before end of warranty, so I can't really
comment on what the manufacturers might be like in that case.

Yes, there will be original manufacturing defects that are mapped out
before shipping.  That's fine and doesn't bother me.  But any drive that
has developed a bad sector after installation will in my experience tend
to develop more in time, and on a few occasions I've seen drives that
reallocate in "bursts" so the count remains fairly stable for a while
then jumps up 40 or 50 sectors within a few minutes.

I generally reckon that as soon as one bad sector appears on an
out-of-warranty drive (which is alerted by SMART monitoring) it's time
to start looking at replacement as soon as reasonably possible, subject
to drive availability and a good time for the swapout and rebuild.  That
might mean next-day a drive and replace immediately or it might mean
within a couple of weeks, depending on drive availability and the
operational cost of a total array failure.

I did come across a customer array on one occasion with between 50 and
1200 reallocated sectors on each of the 12 drives in the array.  it was
working and generally performance was as expected, but I would not have
dared to replace/rebuild any of those disks (it was ultimately done as a
complete new array and data migration).

As always, this is my (experience-based) opinion and your mileage may vary.

Regards,

Geoff.

-- 
Geoff Back
What if we're all just characters in someone's nightmares?

