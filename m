From: Neil Brown <neilb@suse.de>
Subject: Re: md reports: unknown partition table - fixed.
Date: Thu, 20 Jul 2006 10:33:46 +1000
Message-ID: <17598.53098.732139.882100@cse.unsw.edu.au>
References: <44BD0FC3.3010304@dgreaves.com>
	<44BD2A7A.5040906@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Tuesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 18, david@dgreaves.com wrote:
> 
> I think there's a bug here somewhere. I wonder/suspect that the
> superblock should contain the fact that it's a partitioned/able md device?

I've thought about that and am not in favour.
I would rather just assume everything is partitionable - put
  CREATE auto=part

in mdadm.conf

If this causes problems, then those problems need to be identified and
fixed.

NeilBrown
