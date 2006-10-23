From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 Recovery
Date: Mon, 23 Oct 2006 14:01:22 +1000
Message-ID: <17724.16018.816927.697064@cse.unsw.edu.au>
References: <BAYC1-PASMTP06741EF4074D618C18E59FE8030@CEZ.ICE>
	<1161479672.14505.10.camel@localhost>
	<17724.6902.507094.791289@cse.unsw.edu.au>
	<BAYC1-PASMTP03983D4F0B5666E72D056AE8000@CEZ.ICE>
	<1161571953.4871.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Cavan on Sunday October 22
Sender: linux-raid-owner@vger.kernel.org
To: nrcavan@engmail.uwaterloo.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 22, nrcavan@engmail.uwaterloo.ca wrote:
> The drives have not been repartitioned.
> 
> I think what happened is that I created a new raid5 array over the old
> one, but never synced or initialized it.

If you created an array - whether it synced or not - the superblock
would be written and --examine would have found them.  So there must
be something else that happened.  Hard to know what.

> 
> I'm leery of re-creating the array as you suggest, because I think
> re-creating an array "over top" of my existing array is what got me into
> trouble in the first place.
> 
> Also, from mdadm man page (using v 1.12.0):
> 
> --assume-clean
>     Tell mdadm that the array pre-existed and is known to be clean.
>     This is only really useful for Building RAID1  array.   Only
>     use this if you really know what you are doing.  This is currently
>     only supported for --build.
> 
> This suggests to me that I can only use this to build a legacy array
> without superblocks - which I don't want - and that since my array was
> RAID5, that it's not "really useful", whatever that means. Oh, and also,
> I don't really know what I'm doing. ;)

--assume-clean was extended to --create in mdadm-2.2.

> 
> If I do re-create the array to regenerate the superblocks, isn't it
> important that I know the exact parameters of the pre-existing array, to
> get the data to match up? chunk size, parity method, etc?

Yes, but I would assume you just used the defaults.  If not, you
presumably know why you changed the defaults and can do it again???

In any case, creating the array with --assume-clean does not modify
any data.  It only overwrites the superblocks.  As you currently don't
have any superblock, you have nothing to lose.
After you create the array you can try 'fsck' or other tools to see if
the data is intact.  If it is - good.  If not, stop the array and try
creating it with different parameters.

> 
> I just don't want to rush in and mess things up. Did that once
> already. ;)

Very sensible.  
Assuming the partitions really are the same as they were before (can't
hurt to triple-check) then I really thing '--create --assume-clean' is
your best bet.  Maybe download and compile the latest mdadm
 http://www.kernel.org/pub/linux/utils/raid/mdadm/
to make sure you have a working --assume-clean.

NeilBrown
