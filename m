From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: md resync ignoring unreadable sectors
Date: Sun, 08 Feb 2015 10:49:54 +1100
Message-ID: <54D6A4A2.20909@eyal.emu.id.au>
References: <20150208024745.01b9d3ff@natsu>	<54D69433.9060605@eyal.emu.id.au> <20150208040438.156a8554@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150208040438.156a8554@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/15 10:04, Roman Mamedov wrote:
> On Sun, 08 Feb 2015 09:39:47 +1100
> Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
>
>> The error did not show up during normal operation (or during scrub), only during the smartctl long test.
>> What triggered the error for you?
>
> Just appeared during boot-up after a reboot (after 50 days uptime) which was
> performed for some hardware upgrades (RAM, SATA controller). The error doesn't
> go away after swapping the SATA controller for different one.
>
>> I looked up the size of the different parts of the RAID to arrive at that conclusion. Dumping the sectors
>> around the bad area also showed it to be all zeroes.
>
> I wouldn't expect mdadm to have any headers or unused areas as far as 133 MB
> into a RAID member.
>

You can also read the earlier discussion starting 26/Feb/14:
	Subject: how to handle bad sectors in md control areas?

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
