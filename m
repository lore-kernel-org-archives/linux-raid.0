From: Patrick Smears <patrick@smears.org>
Subject: Re: mdadm fails to recognise DDF partitions from Marvell MV64460
 controller
Date: Sat, 7 Dec 2013 16:29:01 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1312062330500.894@eta.ensoft.co.uk>
References: <52A20CFC.7050802@smears.org> <20131207092820.66c7be92@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131207092820.66c7be92@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 7 Dec 2013, NeilBrown wrote:

>> I think I can come up with a patch to work around this - should I do
>> that and submit it (and if so, where should I send it)? Or would it be
>> better to describe the issues I've found in more detail first?
>
> A patch is often a good way to describe an issue in detail - though you 
> should include plain-language text as well of course. Patches can be 
> posted to this list.

Great, thanks - I'll see what I can come up with.

> The only "DDF" I've come across which mdadm doesn't like is DDFv1.0 
> which has all multi-byte values in the "other" order, and uses a 
> different checksum algorithm.  As I cannot find a document describing 
> DDFv1.0 I cannot calculate the checksum so I cannot update the metadata, 
> so I cannot use DDFv1.0.

The metadata claims to be DDFv1.2, but the implementation appears to be 
buggy. One of the bugs is that the CRC is non-standard, but I've managed 
to figure out how it calculates it, so it should be possible to update the 
metadata OK. I'll include full details with the patch.

-P

> If the "minor" variances you found don't prevent us from being able to 
> update the metadata and still have it recognised by the card, then I'm 
> certainly interested in a patch.
>
> Thanks,
> NeilBrown
>

-- 
* Ensoft Limited, Registered in Cardiff No. 3351902
* Registered Office: 13 Station Road, Finchley, London N3 2SB

