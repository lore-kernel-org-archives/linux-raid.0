From: Roman Mamedov <rm@romanrm.net>
Subject: Re: md resync ignoring unreadable sectors
Date: Sun, 8 Feb 2015 04:04:38 +0500
Message-ID: <20150208040438.156a8554@natsu>
References: <20150208024745.01b9d3ff@natsu>
	<54D69433.9060605@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54D69433.9060605@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 08 Feb 2015 09:39:47 +1100
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> The error did not show up during normal operation (or during scrub), only during the smartctl long test.
> What triggered the error for you?

Just appeared during boot-up after a reboot (after 50 days uptime) which was
performed for some hardware upgrades (RAM, SATA controller). The error doesn't
go away after swapping the SATA controller for different one.

> I looked up the size of the different parts of the RAID to arrive at that conclusion. Dumping the sectors
> around the bad area also showed it to be all zeroes.

I wouldn't expect mdadm to have any headers or unused areas as far as 133 MB
into a RAID member.

-- 
With respect,
Roman
