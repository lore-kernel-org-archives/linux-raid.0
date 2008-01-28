From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] Use new sb type
Date: Mon, 28 Jan 2008 19:32:42 +0000
Message-ID: <479E2DDA.5040102@dgreaves.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479E232E.1030801@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479E232E.1030801@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org, Jan Engelhardt <jengelh@computergmbh.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> David Greaves wrote:
>> Jan Engelhardt wrote:
>>> This makes 1.0 the default sb type for new arrays.
>>>
>>
>> IIRC there was a discussion a while back on renaming mdadm options
>> (google "Time
>> to  deprecate old RAID formats?") and the superblocks to emphasise the
>> location
>> and data structure. Would it be good to introduce the new names at the
>> same time
>> as changing the default format/on-disk-location?
>>
>> David
> 
> Also wasn't the concession to make 1.1 default instead of 1.0 ?
> 
IIRC Doug Leford did some digging wrt lilo + grub and found that 1.1 and 1.2
wouldn't work with them. I'd have to review the thread though...

David
