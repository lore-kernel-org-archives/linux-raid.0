From: =?UTF-8?Q?Jure_Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Subject: Re: (user) Help needed: mdadm seems to constantly touch my disks
Date: Sun, 18 Dec 2016 20:40:04 +0100
Message-ID: <CAJ=9zieazbqvWaMXPF1hUL+M5rpvswx5kcbBqU5crcgYi7Qg5Q@mail.gmail.com>
References: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com>
 <871sxbz4yz.fsf@notabene.neil.brown.name> <CAJ=9zieRuTNiEGuB_RouqbdLGoxNkn09yiogR6rND84LtMdbxA@mail.gmail.com>
 <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My further attempts to solve this issue include the following (all
unsuccessful):

1. Installing a fresh Ubuntu, assemble the array
2. Install OpenSUSE, assemble the array
3. Tear the array down, create it anew from scratch (it now has a new
UUID, but the data seems to have been preserved, so my bcache / LVM2
configuration remains the same) - interestingly though: during initial
array rebuild which took the better part of today, there was no
clicking even though drives were constantly in action. Either it was
inaudible or the touching didn't take place.

I think I'm barking up the wrong tree with these experiments. Not sure
how to proceed from here.

LP,
Jure

On Thu, Dec 15, 2016 at 8:01 AM, Jure Erzno=C5=BEnik
<jure.erznoznik@gmail.com> wrote:
> Thanks for helping Neil. I have run the suggested utilities and here
> are my findings:
>
> It is always [kworker/x:yy] (x:yy changes somewhat) or [0].
> A few lines from one of the outputs:
>
>   9,0    3        0     0.061577998     0  m   N raid5 rcw 3758609392 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137872647     0  m   N raid5 rcw 3758671448 2 0=
 1
>   9,0    3        0     4.137872647     0  m   N raid5 rcw 3758671448 2 0=
 1
>   9,0    3        0     4.137872647     0  m   N raid5 rcw 3758671448 2 0=
 1
>
> LP,
> Jure
>
> On Wed, Dec 14, 2016 at 2:15 AM, NeilBrown <neilb@suse.com> wrote:
>> On Tue, Dec 13 2016, Jure Erzno=C5=BEnik wrote:
>>
>>> First of all, I apologise if this mail list is not intended for layman
>>> help, but this is what I am and I couldn't get an explanation
>>> elsewhere.
>>>
>>> My problem is that (as it seems) mdadm is touching HDD superblocks
>>> once per second, once at address 8 (sectors), next at address 16.
>>> Total traffic is kilobytes per second, writes only, no other
>>> detectable traffic.
>>>
>>> I have detailed the problem here:
>>> http://unix.stackexchange.com/questions/329477/
>>>
>>> Shortened:
>>> kubuntu 16.10 4.8.0-30-generic #32, mdadm v3.4 2016-01-28
>>> My configuration: 4 spinning platters (/dev/sd[cdef]) assembled into a
>>> raid5 array, then bcache set to cache (hopefully) everything
>>> (cache_mode =3D writeback, sequential_cutoff =3D 0). On top of bcache
>>> volume I have set up lvm.
>>>
>>> * iostat shows traffic on sd[cdef] and md0
>>> * iotop shows no traffic
>>> * iosnoop shows COMM=3D[idle, md0_raid5, kworker] as processes working
>>> on the disk. Blocks reported are 8, 16 (data size a few KB) and
>>> 18446744073709500000 (data size 0). That last one must be some virtual
>>> thingie as the disks are nowhere near that large.
>>> * enabling block_dump shows md0_raid5 process writing to block 8 (1
>>> sectors) and 16 (8 sectors)
>>>
>>> This touching is caused by any write into the array and goes on for
>>> quite a while after the write has been done (a couple of hours for
>>> 60GB of writes). When services actually work with the array, this
>>> becomes pretty much constant.
>>>
>>> What am I observing and is there any way of stopping it?
>>
>> Start with the uppermost layer which has I/O that you cannot explain.
>> Presumably that is md0.
>> Run 'blktrace' on that device for a little while, then 'blkparse' to
>> look at the results.
>>
>>  blktrace -w 10 md0
>>  blkparse *blktrace*
>>
>> It will give the name of the process that initiated the request in [] at
>> the end of some lines.
>>
>> NeilBrown
