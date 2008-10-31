From: Wolfgang Denk <wd@denx.de>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 20:58:54 +0100
Message-ID: <20081031195854.9A04681122D2@gemini.denx.de>
References: <430424.80078.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <430424.80078.qm@web30802.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Mike Myers,

In message <430424.80078.qm@web30802.mail.mud.yahoo.com> you wrote:
> Well, I can get the 16 port adaptecs for the same price ($100) from a local shop disposing of servers from failed companies. So the price isn't an issue.  It's density.  I'd like to be able to hang 24+ drives off one system, so I can't get there by usin
> g 4 port PCI-E cards.   Not enough slots, and the 4 port cards cost almost as much as the 16 port port adaptecs I can get.

Are the adaptec drivers completely open source by now?  Last  time  I
had  such  a  beast theey depended on a binary-ony module which would
make each and every kernel update a major PITA.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"I'm not a god, I was misquoted."                 - Lister, Red Dwarf
