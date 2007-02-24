From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sat, 24 Feb 2007 17:58:31 +1100
Message-ID: <45DFE217.3020703@eyal.emu.id.au>
References: <45DF859B.2050108@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45DF859B.2050108@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did a resync since, which ended up with the same mismatch_cnt of 184.
I noticed that the count *was* reset to zero when the resync started,
but ended up with 184 (same as after the check).

I thought that the resync just calculates fresh parity and does not
bother checking if it is different. So what does this final count mean?

This leads me to ask: why bother doing a check if I will always run
a resync after an error - better run a resync in the first place?

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
