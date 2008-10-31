From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 11:07:23 -0700 (PDT)
Message-ID: <430424.80078.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I can get the 16 port adaptecs for the same price ($100) from a local shop disposing of servers from failed companies. So the price isn't an issue.  It's density.  I'd like to be able to hang 24+ drives off one system, so I can't get there by using 4 port PCI-E cards.   Not enough slots, and the 4 port cards cost almost as much as the 16 port port adaptecs I can get.

What I am asking about is the comparative performance of 8 and 16 port SATA controllers being used in software raid.  It makes no sense to do this if you are paying retail prices for them I know...  

So, back to the question at hand - what is the best performing 8 or 16 port SATA controller (hardware raid on board or not) available?

Thx
Mike




----- Original Message ----
From: Wolfgang Denk <wd@denx.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mike Myers <mikesm559@yahoo.com>; linux-raid@vger.kernel.org
Sent: Friday, October 31, 2008 5:19:46 AM
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid

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



      
