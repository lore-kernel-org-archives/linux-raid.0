From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Raid5 device hangs in active state
Date: Sun, 11 Mar 2012 19:18:36 -0500
Message-ID: <4F5D40DC.9080304@nuclearwinter.com>
References: <4F0A129E.5020706@nuclearwinter.com> <4F5D3562.6060507@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5D3562.6060507@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Observation:

Setting vm/dirty_background_bytes to 1MB increased my reshape speed by
50% and reduced the resize2fs write interval from once per 5-6 seconds
to once per 3-4 seconds. Changing vm/dirty_bytes didn't have any
noticeable affect until it got below 50MB at which point performance
dropped dramatically.

Prior to dialing the knobs, dirty_ratio was 20% and
dirty_background_ratio was 10%. The system has 8GB installed.

On 3/11/2012 6:29 PM, Asdo wrote:
> On 01/08/12 23:03, Larkin Lowrey wrote:
>> ...
>> Interestingly, to me, when in this state, 'iostat -dx 1' shows the root
>> ...
>
> Do you have any  "avgqu-sz"  stuck at nonzero value in iostat -dx 1?

Yes, avgqu-sz is 1.00.

>
>
> BTW this bug could be related to the recent post by Milan Broz,
> subject: "md raid5 fsync deadlock" .
> Because also in your case fsyncs are not likely to complete... correct?

I do get writes, now about one 4k block every 3-4 seconds. It is quite
possible that our two issues are related.

--Larkin
