From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 08:11:38 +0100
Message-ID: <20110119071138.7B2D02FC@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: stefan.huebner@stud.tu-ilmenau.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Roberto Spadim,

In message <AANLkTi=v6yA_0OOfi2ymA67X0x+KsvV9VC5OgG+0DvKq@mail.gmail.com> you wrote:
> maybe removing hwraid and using swraid may reduce speed (depend how
> much cpu you use with hw and with sw)
> what we can optimize? less I/O per seconds making as much useful
> read/write data on array, how? good read/write algorithms for raid.
> (for each device type, ssd, hd) but... like stefan, disks are your
> bottleneck

No, they are not.  Run some benchmarks yourself if you don't believe
me.

Even a single disk drive is performing better than the hw RAID under
this workload.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
WARNING:  This Product Attracts Every Other Piece  of  Matter in  the
Universe, Including the Products of Other Manufacturers, with a Force
Proportional  to the Product of the Masses and Inversely Proportional
to the Distance Between Them.
