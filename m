From: Phil Turmel <philip@turmel.org>
Subject: Re: Ubuntu crashed during RAID6 grow
Date: Fri, 20 Nov 2015 09:22:15 -0500
Message-ID: <564F2C97.3020500@turmel.org>
References: <loom.20151119T222250-428@post.gmane.org>
 <alpine.DEB.2.02.1511200745170.24520@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1511200745170.24520@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Nathan Peterson <nathan@uwgrads.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/20/2015 01:48 AM, Mikael Abrahamsson wrote:
> On Thu, 19 Nov 2015, Nathan Peterson wrote:
> 
>> Details after the grow:
>>
>> md126 : active (auto-read-only) raid6 sdj1[2] sdl1[3] sdf1[9] sdn1[11]
>> (S) sdi1[1] sdg1[10] sde1[8] sdh1[0] sdk1[4] sdo1[12]
>>
>>  Delta Devices : 1, (8->9)
> 
> Please post mdadm --examine from all component drives, but I'd say if
> you try to access your data everything should be there and the grow
> should continue once the array is not auto-read-only anymore (guess from
> my side though).

Concur.  There's nothing wrong with your array, and yes, mdadm knows
that it was in the middle of a --grow operation.  Mount it and carry on.

Phil
