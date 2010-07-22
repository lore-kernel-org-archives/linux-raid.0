From: Eddy Zhao <eddy.y.zhao@gmail.com>
Subject: Re: BUG REPORT: md RAID5 write throughput will drop for 1~2s every
	16s (under 1Hz sample rate)
Date: Thu, 22 Jul 2010 19:21:18 +0800
Message-ID: <AANLkTinEZpOlTdiLyrTdIFihWkQLN1rZIJ_WtFhg2Jzx@mail.gmail.com>
References: <AANLkTin4T27FUSAWktl-gAHm1yseXcIMTc-7WEPkCOu6@mail.gmail.com>
	<20100720224327.69ff1967@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100720224327.69ff1967@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil:

Sorry for the late reponse (busy at other stuff)

>
> If I'm interpreting your numbers correctly, it is just an occasional single
> write that is slow - not a series of writes during a one second interval that
> are each slow.  It would help if you could confirm that.
>

No.

"output.txt" interpretation
 - "max rw": max per-512KB-block write time in one second
 - "speed": average write throughput in one second

"speed" reveals: It is an occasional single write-throughput-per-second is slow


>
> I don't know where you got 16 from
>

Sorry, I do the wrong math


>
> For some reason raid5 sometimes decides that it needs to pre-read the
>  'other' block to calculate parity rather than waiting for the other block
>  to be written
>
>

Verifying using blktrace...
(Now I can reproduce the problem on "virtual machine + virtual disk",
with kernel 2.6.34)


>
> I'd be keen to hear about any further discoveries you make.
>

OK.

BTW, can you reproduce the problem and help debug on this ?
My debugging process will very slow (not familiar with RAID code)


Thanks
Eddy
