From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Mon, 5 Nov 2007 13:35:59 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <18222.16003.92062.970530@notabene.brown>  <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-2043971365-1194287759=:11422"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754294AbXKESgU@vger.kernel.org>
In-Reply-To: <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-2043971365-1194287759=:11422
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 5 Nov 2007, Dan Williams wrote:

> On 11/4/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> On Mon, 5 Nov 2007, Neil Brown wrote:
>>
>>> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>>>> # ps auxww | grep D
>>>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMA=
ND
>>>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdfl=
ush]
>>>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdfl=
ush]
>>>>
>>>> After several days/weeks, this is the second time this has happened, w=
hile
>>>> doing regular file I/O (decompressing a file), everything on the devic=
e
>>>> went into D-state.
>>>
>>> At a guess (I haven't looked closely) I'd say it is the bug that was
>>> meant to be fixed by
>>>
>>> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
>>>
>>> except that patch applied badly and needed to be fixed with
>>> the following patch (not in git yet).
>>> These have been sent to stable@ and should be in the queue for 2.6.23.2
>>>
>>
>> Ah, thanks Neil, will be updating as soon as it is released, thanks.
>>
>
> Are you seeing the same "md thread takes 100% of the CPU" that Jo=EBl is
> reporting?
>

Yes, in another e-mail I posted the top output with md3_raid5 at 100%.

Justin.
---1463747160-2043971365-1194287759=:11422--
