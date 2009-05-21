From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: "raid array not clean" messages
Date: Wed, 20 May 2009 21:56:18 -0700
Message-ID: <4A43563A-43D5-437D-A916-0DCCB1A61239@gmail.com>
References: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com> <37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 5H11)
Content-Type: text/plain; charset=utf-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: fibre raid <fibreraid@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just curious why you would like to disable the messages. When you =20
create a raid 5/6 array, until parity is fully calculated and written =20
your array /will/ be dirty!

Time flies like an arrow.
=46ruit flies like a banana.

On May 20, 2009, at 21:49, SandeepKsinha <sandeepksinha@gmail.com> =20
wrote:

> Hi,
>
> On Thu, May 21, 2009 at 10:06 AM, fibre raid <fibreraid@gmail.com> =20
> wrote:
>> Hi,
>>
>> Right now, whenever a parity RAID (like raid5 or raid6) is created,
>> something (md itself or mdadm) is dumping a message to the console
>> about "raid array not clean, background synchronization...". I want =
=20
>> to
>> disable these messages but cannot find a way to do so. Can you =20
>> advise?
>> thanks!
>>
>
> Do you mean creating a new array or assembling an existing one ?
>
> AFAIK,
> You can get this message when you are assimilating an existing array
> if you array is not clean and needs recovery.
>
> But ideally you should not get this when creating a new array.
>> -Thomas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-=20
>> raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --=20
> Regards,
> Sandeep.
>
>
>
>
>
>
> =E2=80=9CTo learn is to change. Education is a process that changes t=
he lear=20
> ner.=E2=80=9D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-=20
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
