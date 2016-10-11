From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Why not just return an error?
Date: Tue, 11 Oct 2016 18:01:07 +0800
Message-ID: <e8f6f28d-5d64-f824-daaa-7c0c0072b751@fnarfbargle.com>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
 <57F7DF05.8090605@yandex.ru>
 <b9e7054f-8d68-c576-41a5-aec60c53aa9b@youngman.org.uk>
 <20161010213726.GA3757@metamorpher.de> <57FC0E65.1050407@youngman.org.uk>
 <a1fd81ef-c52e-8d10-e754-984e3f7be60e@fnarfbargle.com>
 <57FCAE74.7070100@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57FCAE74.7070100@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Dark Penguin <darkpenguin@yandex.ru>, Phil Turmel <philip@turmel.org>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/10/16 17:18, Wols Lists wrote:
> On 11/10/16 05:00, Brad Campbell wrote:

>>> The point is that the disk sector is not bad. So you don't want to mark
>>> it as bad on the disk. But you know that the *data* in that block is
>>> bad, so you want the disk access layer to fake a read error when you try
>>> to read it. The intent is to deliberately trigger a rewrite by md.
>>
>> I suggested this a while ago. Take the badblocks log, use hdparm to mark
>> each bad sector as bad and put the drive back in the array. I even
>> suggested potentially adding a feature to ddrescue to auto-mark the
>> blocks as bad on the target drive.
>
> But does that mean that the drive thinks those sectors are bad, and that
> they're then lost permanently at the hardware level? That's what I
> thought the badblocks list did with hdparm, and that's what I was trying
> to avoid.

I've not used bad blocks list, but a cursory read would indicate it only 
records a bad block if the writeback fails. That won't ever happen with 
a bad sector created with hdparm. All hdparm does is corrupt the EEC on 
the block so a read always returns dud. A write solves that issue nicely.

Regards,
Brad

