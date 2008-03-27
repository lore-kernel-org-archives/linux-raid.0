From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Thu, 27 Mar 2008 03:02:45 +0100
Message-ID: <bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
	 <20080325233649.GA632@rap.rap.dk>
	 <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com>
	 <20080326072416.GA8674@rap.rap.dk>
	 <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>
	 <20080326192935.GB18621@rap.rap.dk> <47EAACAB.7070203@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47EAACAB.7070203@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>  After doing a little research, I see that the original slowest form of PCI
>  was 32 bit 33MHz, with a bandwidth of ~127MB/s.

That's still the prevalent form, for anything else you need an (older)
server or workstation board. 133MB/s in theory, 80-100MB/s in
practice.

>  The most common hardware used the v2.1 spec, which was 64 bit at 66MHz.

I don't think the spec version has anything to do with speed ratings, really.

>  I would expect operation at UDMA/66

What's UDMA66 got to do with anything?

>  Final thought, these drives are paired on the master slave of the same
>  cable, are they? That will cause them to really perform badly.

The cables are master-only, I'm pretty sure the controller doesn't
even do slaves.


To wrap it up
- on a regular 32bit/33Mhz PCI bus md-RAID10 is hurt really badly by
having to transfer data twice in every case.
- the old 3ware 7506-8 doesn't accelerate RAID-10 in any way, even
though it's a hardware RAID controller, possibly because it's more of
an afterthought.


On the 1+0 vs RAID10 debate ... 1+0 = 10 is usually used to mean a
stripe of mirrors, while 0+1 = 01 is a less optimal mirror of stripes.
The md implementation doesn't really do a stacked raid but with n2
layout the data distribution should be identical to 1+0 / 10.

C.
