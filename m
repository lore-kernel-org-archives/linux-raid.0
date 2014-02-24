From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 12:46:08 +1100
Message-ID: <530AA460.602@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530AA09B.3090708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In my case (see earlier thread "raid check does not..." the pending sector is early
in the device, in sector 261696 of a 4TB component (whole space in one partition of
each component). So yes, inside the data area.

I still have it reported in my daily logwatch, any idea what to try?

   Currently unreadable (pending) sectors detected:
	/dev/sdi [SAT] - 48 Time(s)
	1 unreadable sectors detected

Eyal

On 02/24/14 12:30, Brad Campbell wrote:
> On 22/02/14 02:09, Mikael Abrahamsson wrote:
>>
>
>> If this doesn't seem like a sensible approach, what would be a sensible
>> approach to avoid having pending sectors keep being "pending" even after
>> "check" and "repair"?
>>
>
> The only reason I've ever seen this personally was when the pending sectors were on non-data parts of the drive, like some of the space around the superblock. Have you verified that these issues are really on sectors in the data area? SMART should tell you the LBA of the first error in a read test.
>
> Brad

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
