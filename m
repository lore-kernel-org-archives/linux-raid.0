From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 07:36:56 +0100
Message-ID: <20130128063656.BB93524E481@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org> <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris Murphy,

In message <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com> you wrote:
> Are the drives all the same model? What model? And are they AF disks?

All of the affected arrays are all of the same disks (one system 8 x
Seagate NL35 ST3250623NS; one 6 x Seagate Barracuda ES.2 ST3250310NS;
one 8 x Maxtor MaXLine Plus II 7Y250M0).

To my understanding none of these are AF disks.


> The mismatch number is not divisible by 16, yet your chunk size is 16KB. It is divisible by 4 and 8, so I'm going to guess that the physical sector size is 4096 bytes. If correct, I'm coming up with a maximum of 346GiB worth of sectors may be adversely 
> affected, assuming every sector in the mismatch count is bad (which is probably not true, but could be).

No.  These are all 512 byte sector drives.

> What file system?

ext4 on all of these.

> Have you done only a check or also a repair, either before or after the upgrade? (I'm not suggesting doing a repair now.)

I did only a check.  I rebootetd two of the systems, which made the
mismatch_cnt go back to zero.  Of course I don;t know if this means
everything is fine now.

> A check should cause URE's to be fixed, but you don't get a count against them because chunk and parity end up being the same for the check after being fixed.
> 
> Are there any messages in dmesg for the time of the check? I would like to know what was recorded in dmesg at the time the mismatches were found.

There is absolutely nothing to be seen in the logs; I also routinely
monitor the drives for reallocated, offline uncorrectable and pending
sectors, and nothing can be seen here either.

I would like to point out that all these systems have been up an
running essentially unchanged for many months, even years (OK, the old
Maxtor drive based one needs a disk swap every few weeks, but this is
because the disks have reached EOL). No such problem has been observed
ever before, but now it happens at the first check operation after
switching to Fedora 18, simultaneous on all systems ...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
What is wanted is not the will to believe,  but the will to find out,
which is the exact opposite.
		        -- Bertrand Russell, "Skeptical Essays", 1928
