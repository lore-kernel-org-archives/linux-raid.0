From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm create keeps giving error about existing file system
Date: Wed, 22 Sep 2004 09:37:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16720.47904.866489.549357@cse.unsw.edu.au>
References: <2986.153.90.198.54.1095803066.squirrel@153.90.198.54>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lucas Albers on Tuesday September 21
To: admin@cs.montana.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 21, admin@cs.montana.edu wrote:
> While trying to create a software raid set:
> with the following command:
> mdadm --create etc etc etc
> The correct syntax.
> 
> I get the following error:
> "/dev/blah appears to contain an ext2fs file system"
> 
> I have tried the following methods to resolve the error:
> 1.) deleting the partition,
> then remaking the partiton with a different partition type.
> including the compulsory reboots.
> 
> 2.) clearing the superblock.
> mdadm --zero-superblock /dev/partition
> 
> Any ideas?

It's not an error, it is a warning. 
After the warning, it asks you if you really want to create the raid
array.

Just say "yes".

> Just dd the parition?

no point.

NeilBrown
