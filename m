From: fibre raid <fibreraid@gmail.com>
Subject: Re: "raid array not clean" messages
Date: Wed, 20 May 2009 23:55:01 -0500
Message-ID: <5817fbed0905202155t471b22e4q152e088387d0222d@mail.gmail.com>
References: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com>
	 <37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I receive this message to the console when creating a new array and run=
ning it.

-Thomas

On Wed, May 20, 2009 at 11:49 PM, SandeepKsinha <sandeepksinha@gmail.co=
m> wrote:
> Hi,
>
> On Thu, May 21, 2009 at 10:06 AM, fibre raid <fibreraid@gmail.com> wr=
ote:
>> Hi,
>>
>> Right now, whenever a parity RAID (like raid5 or raid6) is created,
>> something (md itself or mdadm) is dumping a message to the console
>> about "raid array not clean, background synchronization...". I want =
to
>> disable these messages but cannot find a way to do so. Can you advis=
e?
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
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
