From: "John Stoffel" <john@stoffel.org>
Subject: Re: md resync ignoring unreadable sectors
Date: Sun, 8 Feb 2015 12:23:19 -0500
Message-ID: <21719.39815.552196.408539@quad.stoffel.home>
References: <20150208024745.01b9d3ff@natsu>
	<54D69433.9060605@eyal.emu.id.au>
	<20150208040438.156a8554@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150208040438.156a8554@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Roman" == Roman Mamedov <rm@romanrm.net> writes:

Roman> On Sun, 08 Feb 2015 09:39:47 +1100
Roman> Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

>> The error did not show up during normal operation (or during scrub), only during the smartctl long test.
>> What triggered the error for you?

Roman> Just appeared during boot-up after a reboot (after 50 days uptime) which was
Roman> performed for some hardware upgrades (RAM, SATA controller). The error doesn't
Roman> go away after swapping the SATA controller for different one.

>> I looked up the size of the different parts of the RAID to arrive at that conclusion. Dumping the sectors
>> around the bad area also showed it to be all zeroes.

Roman> I wouldn't expect mdadm to have any headers or unused areas as
Roman> far as 133 MB into a RAID member.

Roman,

I would immediately add in a third RAID1 member, wait for it to
resync, then pull out the bad drive and write zeros to the entire
drive to force any and all bad sectors to get over-written and
hopefully reallocated from good sectors.  

But I'd also treat the drive as suspect and replace it ASAP.  Keet it
around as a scratch drive, or a temp space area you don't care about
if you like, but not of important data if at all possible.

John
