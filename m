From: Nix <nix@esperi.org.uk>
Subject: Re: md reports: unknown partition table - fixed.
Date: Sat, 22 Jul 2006 22:32:19 +0100
Message-ID: <87ac71gwbg.fsf@hades.wkstn.nix>
References: <44BD0FC3.3010304@dgreaves.com> <44BD2A7A.5040906@dgreaves.com>
	<17598.53098.732139.882100@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17598.53098.732139.882100@cse.unsw.edu.au> (Neil Brown's message of "20 Jul 2006 01:34:36 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20 Jul 2006, Neil Brown uttered the following:
> On Tuesday July 18, david@dgreaves.com wrote:
>> 
>> I think there's a bug here somewhere. I wonder/suspect that the
>> superblock should contain the fact that it's a partitioned/able md device?
> 
> I've thought about that and am not in favour.
> I would rather just assume everything is partitionable - put
>   CREATE auto=part

As long as `partitionable' doesn't imply `partitioned': I'd quite like
LVM-on-raw-md to keep working...

-- 
`We're sysadmins. We deal with the inconceivable so often I can clearly 
 see the need to define levels of inconceivability.' --- Rik Steenwinkel
