From: David Greaves <david@dgreaves.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 08:43:37 +0100
Message-ID: <4449DEA9.2060107@dgreaves.com>
References: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Hopkins <sah@coraid.com>
Cc: linux-raid@vger.kernel.org, jrs@abhost.net, support@coraid.com
List-Id: linux-raid.ids

Sam Hopkins wrote:
> Hello,
>
> I have a client with a failed raid5 that is in desperate need of the
> data that's on the raid.  The attached file holds the mdadm -E
> superblocks that are hopefully the keys to the puzzle.  Linux-raid
> folks, if you can give any help here it would be much appreciated.
>   
Have you read the archive? There were a couple of similar problems
earlier this month.
take a look at 2 April 06 - "help recreating a raid5"
Also "Re: help wanted - 6-disk raid5 borked: _ _ U U U U"

> # mdadm -V
> mdadm - v1.7.0 - 11 August 2004
>   
Can't hurt to upgrade mdadm
> # uname -a
> Linux hazel 2.6.13-gentoo-r5 #1 SMP Sat Jan 21 13:24:15 PST 2006 i686 Intel(R) Pentium(R) 4 CPU 2.40GHz GenuineIntel GNU/Linux
>
> Here's my take:
>
> Logfiles show that last night drive /dev/etherd/e0.4 failed and around
> noon today /dev/etherd/e0.0 failed.  This jibes with the superblock
> dates and info.
>
> My assessment is that since the last known good configuration was
> 0 <missing>
> 1 /dev/etherd/e0.0
> 2 /dev/etherd/e0.2
> 3 /dev/etherd/e0.3
>
> then we should shoot for this.  I couldn't figure out how to get there
> using mdadm -A since /dev/etherd/e0.0 isn't in sync with e0.2 or e0.3.
> If anyone can suggest a way to get this back using -A, please chime in.
>   
See the patch Molle provided - it seemed to work for him and took the
guesswork out of the create parameters.
I personally didn't use it since Neil didn't bless it :)
> The alternative is to recreate the array with this configuration hoping
> the data blocks will all line up properly so the filesystem can be mounted
> and data retrieved.  It looks like the following command is the right
> way to do this, but not being an expert I (and the client) would like
> someone else to verify the sanity of this approach.
>
> Will
>
> mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]
>
> do what we want?
>   
It looks right to me - but see comments below...
Also, can you take disk images of the devices (dd if=/dev/etherd/e0.0
of=/somewhere/e0.0.img) to allow for retries?
> ------------------------------------------------------------------------
>
> /dev/etherd/e0.0:
>          Events : 0.3488315
> /dev/etherd/e0.2:
>          Events : 0.3493633
> /dev/etherd/e0.3:
>          Events : 0.3493633
> /dev/etherd/e0.4:
>          Events : 0.3482550
>   
I don't know precisely what 'Events' are but I read this as being a lot
of activity on e0.[23] after e0.0 went down.
I think that's odd.
Maybe the kernel isn't stopping the device when it degrades - I seem to
remember something like this but I'm probably wrong... archives again...

This shouldn't affect the situation you're now in (horse,bolt,door etc)
but fixing it may make life better should another problem like this
occur - or it may not. Eventually there may be info in a wiki to help
understand this stuff.

HTH

David

-- 

