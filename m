From: Henrik Olsson <henrik@fixme.se>
Subject: Re: Mixing 512 bytes and 4K sector harddrives in a raid1?
Date: Mon, 7 Feb 2011 15:08:17 +0100
Message-ID: <AANLkTin9zT62t6fBY5Zjxj8HqJHKo1224u3CN+1CWnph@mail.gmail.com>
References: <AANLkTi=43ujbivEtgq1fyn0hnRRXvJJKmojf7LZhtid9@mail.gmail.com>
	<iiotq0$gpa$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iiotq0$gpa$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 7, 2011 at 14:56, David Brown <david@westcontrol.com> wrote=
:
> On 07/02/2011 12:41, Henrik Olsson wrote:
>>
>> Hi,
>>
>> One of the drives in my raid1 recently crashed and it looks like all
>> the replacement disks (2TB) i can find use 4K sectors, but the old
>> ones were 512 bytes.
>> Are there any issues with having a raid1 array with different sector
>> sizes for the drives?
>>
>> Regards,
>> Henrik
>
> I can't answer for sure, but I would think there would be no problem =
as long
> as you make sure your partitions are 4 KB aligned. =A0AFAIUI, Linux a=
lways
> writes in 4K blocks to the disks anyway, so alignment is the only iss=
ue -
> and that's a performance issue, not a correctness one.
>
>

Yes, that's the impression i've gotten after reading about it too.
As long as i create a 4KB aligned partition on the new drive that is
at least as large as the old one and replace the old one with it in
the array, it should just work?

I run dmcrypt and then lvm on top of the raid array though, trying to
figure out what needs to be done with alignment with those...

Worst case i should be able to create a new properly aligned
array/dmcrypt/lvm on the new drive, copy the old data over and add the
old working drive to the new array since if it's 4K aligned it should
also be 512B aligned?

/Henrik
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
