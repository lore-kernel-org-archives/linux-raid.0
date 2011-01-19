From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 09:18:53 +0100
Message-ID: <4D369E6D.8020604@stud.tu-ilmenau.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com> <20110119071138.7B2D02FC@gemini.denx.de>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119071138.7B2D02FC@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 19.01.2011 08:11, schrieb Wolfgang Denk:
> Dear Roberto Spadim,
> 
> In message <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com> you wrote:
>> maybe removing hwraid and using swraid may reduce speed (depend how
>> much cpu you use with hw and with sw)
>> what we can optimize? less I/O per seconds making as much useful
>> read/write data on array, how? good read/write algorithms for raid.
>> (for each device type, ssd, hd) but... like stefan, disks are your
>> bottleneck
> 
> No, they are not.  Run some benchmarks yourself if you don't believe
> me.

Lol - I wouldn't have answered in the first place if I didn't have any
expertise.  So suit yourself - as you don't bring up any real numbers
(remember: you've got the weird setup, you asked, you don't have enough
money for the enterprise solution - so ...) nobody who worked with 3ware
controllers will believe you.

> 
> Even a single disk drive is performing better than the hw RAID under
> this workload.

Well - that is the problem - simulate YOUR workload.  Actually I fear at
least one of your disks has a grown defect, which slows down / blocks
i/o.  Haven't seen any 9650SE RAID being slower than the same config in
a software raid.

> 
> Best regards,
> 
> Wolfgang Denk
> 

