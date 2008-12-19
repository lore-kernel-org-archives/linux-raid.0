From: Wolfgang Denk <wd@denx.de>
Subject: Re: Supermicro AOC-SAT2-MV8
Date: Sat, 20 Dec 2008 00:10:57 +0100
Message-ID: <20081219231057.08160834B04E@gemini.denx.de>
References: <C571C6FB.BA32%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <C571C6FB.BA32%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: Max Waterman <davidmaxwaterman@fastmail.co.uk>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Iain Rauch,

In message <C571C6FB.BA32%groups@email.iain.rauch.co.uk> you wrote:
>
> If you have PCIe slots (which is likely if the board is less than a couple

But the Supermicro card is a PCI-X card - AFAIK there are no PCIe
versions available (yet?).

> of years old), you are better to use them as they are faster than PCI/PCI-X.

Ummm. It depends. Throughput can be hight, but I think latencies  are
higher,  too.  So the actual performance depends on your system load.
If you have enough small requests PCI-X may even be faster.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Living on Earth may be expensive, but it includes an annual free trip
around the Sun.
