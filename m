From: Learner Study <learner.study@gmail.com>
Subject: Re: Linux Raid performance
Date: Sun, 4 Apr 2010 11:26:44 -0700
Message-ID: <w2j7efa8a7d1004041126id2b84d47k7bd275606712d0e3@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	<20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
	<20100402110506.GA16294@rap.rap.dk> <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
	<l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
	<4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org>
	<4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB8A979.3020502@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: Richard Scobie <richard@sauce.co.nz>, Mark Knecht <markknecht@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk, learner.study@gmail.com
List-Id: linux-raid.ids

Happy Easter!!!

So, 550-600MB/s is the best we have seen with Linux raid using 16-24 SA=
S drives.

Not sure if its appropriate to ask on this list - has someone seen
better numbers with non-linux raid stack? Perhaps freebsd/lustre..

Thanks for your time!

On Sun, Apr 4, 2010 at 8:00 AM, MRK <mrk@shiftmail.org> wrote:
> Richard Scobie wrote:
>>
>> MRK wrote:
>>
>>> I spent some time trying to optimize it but that was the best I cou=
ld
>>> get. Anyway both my benchmark and Richard's one imply a very signif=
icant
>>> bottleneck somehwere.
>>
>> This bottleneck is the SAS controller, at least in my case. I did th=
e same
>> math regarding streaming performance of one drive times number of dr=
ive and
>> wondered where the shortfall was, after tests showed I could only st=
reaming
>> read at 850MB/s on the same array.
>>
>> A query to an LSI engineer got the following response, which basical=
ly
>> boils down to "you get what you pay for" - SAS vs SATA drives.
>>
>> "Yes, you're at the "practical" limit.
>>
>> With that setup and SAS disks, you will exceed 1200 MB/s. =A0Could g=
o
>> higher than 1,400 MB/s given the right server chipset.
>>
>> However with SATA disks, and the way they break up data transfers, 8=
15
>> to 850 MB/s is the best you can do.
>>
>> Under SATA, there are multiple connections per I/O request.
>> =A0* Command Initiator -> HDD
>> =A0* DMA Setup =A0Initiator -> HDD
>> =A0* DMA Activate =A0HDD -> Initiator
>> =A0* Data =A0 HDD -> Initiator
>> =A0* Status =A0 =A0HDD -> Initiator
>> And there is little ability with typical SATA disks to combine traff=
ic
>> from different I/Os on the same connection. =A0So you get lots of
>> individual connections being made, used, & broken.
>>
>> Contrast that with SAS which has typically 2 connections per I/O, an=
d
>> will combine traffic from more than 1 I/O per connection. =A0It uses=
 the
>> SAS links much more efficiently."
>
> Firstly: Happy Easter! =A0:-)
>
> Secondly:
>
> If this is true then one won't achieve higher speeds even on RAID-0. =
If
> anybody can test this... I cannot right now
>
> I am a bit surprised though. The SATA "link" is one per drive, so if =
1 drive
> is able to do 90MB/sec, N drives on N cables should do Nx90MB/sec.
> If this is not so, then the chipset of the controller must be the
> bottleneck.
> If this is so, the newer LSI controllers at 6.0gbit/sec could be able=
 to do
> better (they supposedly have a faster chip). Also maybe one could buy=
 more
> controller cards and divide drives among those. These two workarounds=
 would
> still be cheaper than SAS drives.
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
