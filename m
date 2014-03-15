From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid stalls during --replace and other disk activity...
Date: Sat, 15 Mar 2014 16:59:45 -0400
Message-ID: <5324BF41.3060401@turmel.org>
References: <CAK_KU4bEFkydyqJfrUWNoq9R7AxVwPU29Kyzp+5mn=tmf7GgHQ@mail.gmail.com>	<5324A7A9.1040700@turmel.org> <CAK_KU4bZnVSPR+mF3AX_sjQjTdnMonP9x+v84g9SEAN5Necr5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4bZnVSPR+mF3AX_sjQjTdnMonP9x+v84g9SEAN5Necr5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/15/2014 03:53 PM, Scott D'Vileskis wrote:
>>
>> This is deliberate, and in my opinion, desirable.  Same thing happens
>> when doing a check or any kind of rebuild on multiple arrays that use
>> partitions on shared underlying devices.  If you don't limit the raid
>> background activity, the extra seek load on the devices can severely cut
>> performance, especially on spinning rust.
>>
> 
> If I was doing a 'normal' resync, I would also agree.
> 
> But my point was this...
> My raid was doing a --replace of /dev/sdf1 with /dev/sde1
> It was only reading/writing from/to those two devices, not the other
> disks in the raid. (i.e. /dev/sd[a-d] were not being used)
> The other job I started (dd if=/dev/zero of=/dev/sda2 bs=1M) was only
> writing to /dev/sda
> 
> These jobs should be are perfectly capable of running in parallel
> without slowing eachother down.

Good point.  If I were Neil, I'd say "Patch Welcome!".  :-)

> I think the logic that pauses a resync on 'related' disk activity
> should treat a --replace slightly different

But I would insist that the solution be generic -- make the existing
logic notice that the activity is on unrelated members, so all
background activity would benefit from the new algorithm.  IMHO.

Phil

