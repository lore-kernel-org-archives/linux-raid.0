From: Tim Southerwood <ts@dionic.net>
Subject: Re: [PATCH] Use new sb type
Date: Tue, 29 Jan 2008 04:09:02 +0000
Message-ID: <479EA6DE.9070503@dionic.net>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479E232E.1030801@rabbit.us> <479E2DDA.5040102@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479E2DDA.5040102@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Peter Rabbitson wrote:
>> David Greaves wrote:
>>> Jan Engelhardt wrote:
>>>> This makes 1.0 the default sb type for new arrays.
>>>>
>>> IIRC there was a discussion a while back on renaming mdadm options
>>> (google "Time
>>> to  deprecate old RAID formats?") and the superblocks to emphasise the
>>> location
>>> and data structure. Would it be good to introduce the new names at the
>>> same time
>>> as changing the default format/on-disk-location?
>>>
>>> David
>> Also wasn't the concession to make 1.1 default instead of 1.0 ?
>>
> IIRC Doug Leford did some digging wrt lilo + grub and found that 1.1 and 1.2
> wouldn't work with them. I'd have to review the thread though...
> 
> David
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

For what it's worth, that was my finding too. -e 0.9+1.0 are fine with
GRUB, but  1.1 an 1.2 won't work under the filesystem that contains
/boot, at least with GRUB 1.x (I haven't used LILO for some time nor
have I tried the development GRUB 2).

The reason IIRC boils down to the fact that GRUB 1 isn't MD aware, and
the only reason one can "get away" with using it on a RAID 1 setup at
all is that the constituent devices present the same data as the
composite MD device, from the start.

Putting an MD SB at/near the beginning of the device breaks this case
and GRUB 1 doesn't know how to deal with it.

Cheers
Tim
