From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Wed, 26 Mar 2008 18:10:17 +0100
Message-ID: <bb145bd20803261010mfe43d25tf381e4d4392f4ed8@mail.gmail.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
	 <72dbd3150803251513v28ea142ct2de229c26e888c56@mail.gmail.com>
	 <bb145bd20803251556pa416a0cs8350058a4216f6f9@mail.gmail.com>
	 <47EA79D1.1090607@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47EA79D1.1090607@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  I think that you should treat 10,n2 and 10,f2 as separate
>  configurations,

Certainly, but f2 write performance is supposed to be even worse than
n2 even in theory. Maybe I'll try it anyway.

>  The ability to transfer a single copy of the data and no parity
>  information is an advantage of hardware controllers.

The 3ware 7506-8 *is* a hardware controller and it quite obviously
does *not* have this ability, at least not for raid10. One can just as
well use the 3ware as a plain 8port controller and md over that,
doesn't make much of a difference. I find that interesting.

Cheers,

C.
