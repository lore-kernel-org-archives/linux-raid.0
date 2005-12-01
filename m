From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: quick Q re raid reconstruction
Date: Fri, 02 Dec 2005 08:55:34 +1100
Message-ID: <438F7156.9000109@eyal.emu.id.au>
References: <438EE429.2030903@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <438EE429.2030903@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Eyal Lebedinsky wrote:
> I have (had) a 4 disk RAID5 /dev/sd[abcd]1.
[trim]

By this evening this will become urgent, so if anyone can
reply then please do.

To bring it up in degraded mode, can I do a --create and tell
it to use sd[abc] and mark sdd as failed? I can then force
--run. An --assemble with '--failed /dev/sdd1' was not happy
because it could not see sdd (naturally).

With the new disk (sda) added, can I safely do
	mdadm --assemble /dev/md0 /dev/sd[bcd]1 --fail /dev/sda1
and maybe --force or --run to bring it up?

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
