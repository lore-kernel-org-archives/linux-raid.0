From: Wolfgang Denk <wd@denx.de>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 11:50:50 +0100
Message-ID: <20081031105050.3B27281122D2@gemini.denx.de>
References: <47751.64665.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <47751.64665.qm@web30802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Mike Myers,

In message <47751.64665.qm@web30802.mail.mud.yahoo.com> you wrote:
>
> I'm curious as to what people think the best SATA controller is
> these days that has 8 or 16 ports per card driving software raid?

The "best" obviously depends on your set of requirements. If you don;t
care about the price the result may be different than when you try to
find a cost-effective solution.

We made really good experience with the Supermicro AOC-SAT2-MV8 cards.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Backed up the system lately?
