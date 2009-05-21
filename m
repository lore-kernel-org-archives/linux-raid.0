From: fibre raid <fibreraid@gmail.com>
Subject: Re: "raid array not clean" messages
Date: Thu, 21 May 2009 00:11:43 -0500
Message-ID: <5817fbed0905202211t6f2b73d3o187906f77383fe5b@mail.gmail.com>
References: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com>
	 <37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
	 <4A43563A-43D5-437D-A916-0DCCB1A61239@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A43563A-43D5-437D-A916-0DCCB1A61239@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Chen <muffaleta@gmail.com>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have no problem with this message being written to
/var/log/messages, but in our case, we don't want it on the console.
We want the console to only be there for kernel crash dumps (if they
occur), nothing else.

-Thomas

On Wed, May 20, 2009 at 11:56 PM, Christopher Chen <muffaleta@gmail.com=
> wrote:
> Just curious why you would like to disable the messages. When you cre=
ate a
> raid 5/6 array, until parity is fully calculated and written your arr=
ay
> /will/ be dirty!
>
> Time flies like an arrow.
> Fruit flies like a banana.
>
> On May 20, 2009, at 21:49, SandeepKsinha <sandeepksinha@gmail.com> wr=
ote:
>
>> Hi,
>>
>> On Thu, May 21, 2009 at 10:06 AM, fibre raid <fibreraid@gmail.com> w=
rote:
>>>
>>> Hi,
>>>
>>> Right now, whenever a parity RAID (like raid5 or raid6) is created,
>>> something (md itself or mdadm) is dumping a message to the console
>>> about "raid array not clean, background synchronization...". I want=
 to
>>> disable these messages but cannot find a way to do so. Can you advi=
se?
>>> thanks!
>>>
>>
>> Do you mean creating a new array or assembling an existing one ?
>>
>> AFAIK,
>> You can get this message when you are assimilating an existing array
>> if you array is not clean and needs recovery.
>>
>> But ideally you should not get this when creating a new array.
>>>
>>> -Thomas
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Regards,
>> Sandeep.
>>
>>
>>
>>
>>
>>
>> =93To learn is to change. Education is a process that changes the le=
arner.=94
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
