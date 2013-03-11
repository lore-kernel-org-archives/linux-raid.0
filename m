From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 01:41:06 +0100
Message-ID: <CAAnFQG8cEhErcVyZAuvYxkBiv0Y0ps+6UHcu459MGxYYMbHXLA@mail.gmail.com>
References: <CAAnFQG9b1mUj+BJ3-_N-HjQi2w2Vv5pg4RCErXW5axp32_7T4g@mail.gmail.com>
 <CADNH=7Ed79h5GetY5XWOu=kKX=YNqVYmN1J6K25MVMwkH_Soyw@mail.gmail.com> <CAAnFQG_KdzFS6u+RrAfdL5gaOa-ozz9YAtb36oFo-ZofaLyxEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAnFQG_KdzFS6u+RrAfdL5gaOa-ozz9YAtb36oFo-ZofaLyxEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 11, 2013 at 1:33 AM, Javier Marcet <jmarcet@gmail.com> wrote:

>>> I have 4.5 TB used and right now I have the filesystem mounted and I
>>> can use it yet the kernel is spiting that same trace over and over
>>> again. I really don't know what would be the best thing to do right
>>> now and would appreciate any help.
>>
>> So how are the drivers doing? smartctl -a for all HDDs please.
>
> http://bpaste.net/raw/82828/

As far as I can see there are only two read errors reported on
/dev/sdb, nothing on the rest.

Also, I finally put the raid completely offline since the data was not
really readable in that state.



-- 
Javier Marcet <jmarcet@gmail.com>
