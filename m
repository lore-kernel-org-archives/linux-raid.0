From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 08:40:01 +0000
Message-ID: <CADNH=7GjmZjzjo-204ONqwF7JyeH7FVN5GEA+6WP9H=+KZz2zQ@mail.gmail.com>
References: <CAAnFQG9b1mUj+BJ3-_N-HjQi2w2Vv5pg4RCErXW5axp32_7T4g@mail.gmail.com>
	<CADNH=7Ed79h5GetY5XWOu=kKX=YNqVYmN1J6K25MVMwkH_Soyw@mail.gmail.com>
	<CAAnFQG_KdzFS6u+RrAfdL5gaOa-ozz9YAtb36oFo-ZofaLyxEw@mail.gmail.com>
	<CAAnFQG8cEhErcVyZAuvYxkBiv0Y0ps+6UHcu459MGxYYMbHXLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAnFQG8cEhErcVyZAuvYxkBiv0Y0ps+6UHcu459MGxYYMbHXLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Javier Marcet <jmarcet@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11 March 2013 00:41, Javier Marcet <jmarcet@gmail.com> wrote:
> On Mon, Mar 11, 2013 at 1:33 AM, Javier Marcet <jmarcet@gmail.com> wrote:
>
>>>> I have 4.5 TB used and right now I have the filesystem mounted and I
>>>> can use it yet the kernel is spiting that same trace over and over
>>>> again. I really don't know what would be the best thing to do right
>>>> now and would appreciate any help.
>>>
>>> So how are the drivers doing? smartctl -a for all HDDs please.
>>
>> http://bpaste.net/raw/82828/
>
> As far as I can see there are only two read errors reported on
> /dev/sdb, nothing on the rest.
>
> Also, I finally put the raid completely offline since the data was not
> really readable in that state.
>
>
>
> --
> Javier Marcet <jmarcet@gmail.com>

Serial Number:    WD-WCAWZ2190021
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       3

Not good. I'd run smartctl -t long, wait for completion, check
results, then run badblocks.

Serial Number:    WD-WCAWZ2200949
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       1

As above. Also, I see no self-tests logged?

Cheers,
Mathias
