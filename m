From: Illtud Daniel <illtud.daniel@llgc.org.uk>
Subject: Re: XP RAID vs md
Date: Fri, 04 Apr 2003 10:46:30 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E8D5476.8B2654E@llgc.org.uk>
References: <3E8AD562.6090707@webmail.co.za> <20030402152731.GE7364@marowsky-bree.de> <3E8D463F.98EFBF1F@llgc.org.uk> <3E8D4E8C.7080503@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Vladimir Milovanovic <vlad@webmail.co.za>
Cc: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Vladimir Milovanovic wrote:
 
> Well Daniel what is your take on this? I am very interested in this
> since I am working on a project which has to use RAID, and performance
> is paramount (after reliability of course).

...in which case I'd go for a hardware SCSI solution. The AMI
Megaraid (now LSI?) cards have served me well. You can afford one
by not buying XP...

> I need to make a decision,
> and I would like very much to stick with md, since it is what I know and
> am used to. But if one can get huge performance margins using XP, then I
> am going to have to consider that.

You must remember that this is RAID0, and says nothing about
other RAID levels. I'm assuming you wouldn't be implementing a
RAID0 (not on its own, anyway - maybe 5+0) if you're looking
for reliability. You've also got to look at where you need the
speed - is this a network file server? In which case your
bottleneck is probably the network, unless you've got more than
two gigabit ethernet cards. Tell us more about what your project
needs RAID for, and we can (probably) tell you that md is just
what you need. I'd be very wary of going over to XP on the back
of this one report, since you're opening yourself up to a load
of extra costs (on everything!). If you've got the money, then
why not just go for hardware SCSI RAID?

I've benchmarked NT4.0's RAID0 of two hardware RAID 5 arrays
against linux's (about a year ago) and linux smoked NT, which
is why this report surprised me, I wasn't aware that XP had
come on so far, and I was after some feedback from the md
developers as to whether they could spot another reason for the
results in the report.

-- 
Illtud Daniel                                 illtud.daniel@llgc.org.uk
Uwch Ddadansoddwr Systemau                       Senior Systems Analyst
Llyfrgell Genedlaethol Cymru                  National Library of Wales
Yn siarad drosof fy hun, nid LlGC   -  Speaking personally, not for NLW
