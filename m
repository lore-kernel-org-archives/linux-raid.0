From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: raid5 messed up
Date: Fri, 1 Sep 2017 23:47:34 +0100
Message-ID: <65e0e7ae-28fd-57d2-c3c1-2ffba4924bd7@youngman.org.uk>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: bishop@latech.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/09/17 21:15, Thomas C. Bishop wrote:
> I messed up my raid5 array . I know a two of HDs are "failure 
> prediction" and one is out.. seagate is shipping me replacements.
> 
> This is my backup server so there's the actual copy of data but I'd 
> prefer to recover the array because other data scripts/tools have crept 
> into it ... mostly junk but would like to verify.
> 
> Here's out put as recommended at 
> https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> Thanks in advance for any assistance,
> 
> TOm

Okay, one failed drive, so it's not looking bad on that front. sdi1 
seems to be the broken one.

Seagates - no mention of the model, or whether SCT/ERC is supported. Are 
they Seagate NAS drives? Read the timeout mismatch / why you shouldn't 
use desktop drives page on the wiki. Could that be the problem?

It's looking good in that nearly all the event counts are identical.

Seagate are sending a replacement? My immediate reaction is to wait 
until it arrives, ddrescue sdi onto it, and then re-assemble the array. 
It'll probably reject the new sdi because of the event mismatch, but it 
might just work fine. If it does reject it, then you can do a --re-add 
which because you've got a bitmap, should bring everything back hunky-dory.

Make sure ddrescue generates a log! If ddrescue can't copy the disk 
completely, get back here with the contents of that log and we'll see if 
we can mark the failed sectors as "bad" on the copy. That way, you can 
safely re-add the drive knowing that a scrub will fall over the bad 
sectors and re-create them correctly.

My gut feeling is that this should be a simple recovery, though if 
you've actually got a spare drive on the array, you should have gone for 
raid-6.

Cheers,
Wol
