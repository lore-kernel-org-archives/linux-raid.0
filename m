From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 09:56:56 +0100
Message-ID: <CAAnFQG8Ca7fkr-vboobr_qmRMTn38U9QP5hiT-9Ps0BqWcunzw@mail.gmail.com>
References: <CAAnFQG9b1mUj+BJ3-_N-HjQi2w2Vv5pg4RCErXW5axp32_7T4g@mail.gmail.com>
 <CADNH=7Ed79h5GetY5XWOu=kKX=YNqVYmN1J6K25MVMwkH_Soyw@mail.gmail.com>
 <CAAnFQG_KdzFS6u+RrAfdL5gaOa-ozz9YAtb36oFo-ZofaLyxEw@mail.gmail.com>
 <CAAnFQG8cEhErcVyZAuvYxkBiv0Y0ps+6UHcu459MGxYYMbHXLA@mail.gmail.com> <CADNH=7GjmZjzjo-204ONqwF7JyeH7FVN5GEA+6WP9H=+KZz2zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GjmZjzjo-204ONqwF7JyeH7FVN5GEA+6WP9H=+KZz2zQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 11, 2013 at 9:40 AM, Mathias Bur=C3=A9n <mathias.buren@gmai=
l.com> wrote:

>>>>> I have 4.5 TB used and right now I have the filesystem mounted an=
d I
>>>>> can use it yet the kernel is spiting that same trace over and ove=
r
>>>>> again. I really don't know what would be the best thing to do rig=
ht
>>>>> now and would appreciate any help.
>>>>
>>>> So how are the drivers doing? smartctl -a for all HDDs please.
>>>
>>> http://bpaste.net/raw/82828/
>>
>> As far as I can see there are only two read errors reported on
>> /dev/sdb, nothing on the rest.
>>
>> Also, I finally put the raid completely offline since the data was n=
ot
>> really readable in that state.
>>
>>
>>
>> --
>> Javier Marcet <jmarcet@gmail.com>
>
> Serial Number:    WD-WCAWZ2190021
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       3
>
> Not good. I'd run smartctl -t long, wait for completion, check
> results, then run badblocks.

By 18:00 today I should have the smartctl results.

>
> Serial Number:    WD-WCAWZ2200949
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       1
>
> As above. Also, I see no self-tests logged?

I hadn't done any test manually but I had smartd running and configured=
=2E


--=20
Javier Marcet <jmarcet@gmail.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
