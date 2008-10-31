From: Wolfgang Denk <wd@denx.de>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 13:19:46 +0100
Message-ID: <20081031121946.7C15D81122D2@gemini.denx.de>
References: <47751.64665.qm@web30802.mail.mud.yahoo.com> <20081031105050.3B27281122D2@gemini.denx.de> <alpine.DEB.1.10.0810310813240.468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.1.10.0810310813240.468@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mike Myers <mikesm559@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Justin Piszcz,

In message <alpine.DEB.1.10.0810310813240.468@p34.internal.lan> you wrote:
> 
> > We made really good experience with the Supermicro AOC-SAT2-MV8 cards.
...
> Lets be frank- almost all(?) RAID controllers you must export the disks 
> via JBOD and they cost hundreds to thousands of dollars.  Doing SW RAID 
> via JBOD IMO is not a great idea-- I'd use individual 2 or 4 port SATA 
> controllers on PCI-e.

Right. The AOC-SAT2-MV8 is a 8 port PCI-X controller without any RAID
support - and costs just around $ 100. That's why I like it.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The optimum committee has no members.
                                                   - Norman Augustine
