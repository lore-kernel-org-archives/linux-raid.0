From: berk walker <berk@panix.com>
Subject: Re: mdadm file system type check
Date: Fri, 16 Mar 2007 20:39:38 -0500
Message-ID: <45FB46DA.7090307@panix.com>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
Sender: linux-raid-owner@vger.kernel.org
To: "William L. Thomson Jr." <wltjr@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



William L. Thomson Jr. wrote:
> To whom it may concern,
>
> 	It seems mdadm does not check, warn, abort, or etc if a partition has
> an incorrect file system type. This has come up for me on a few
> occasions while building servers with software raid. On one occasion I
> had a machine fully up and running on raid partitions that were ext3 not
> linux auto raid/fd.
>
> 	If possible would really be nice if it could do a check for that. Since
> one usually has to start over when they discover the problem and go to
> correct it. Since raidtools is not deprecated, others migrating from it
> on Gentoo are running into it at as well. At the present time mostly
> developers. Really would not want users running into it :)
>
> 	Anyway if that could be addressed that would be great. Not sure if this
> is the right place for this or not. If not please advise, thank you.
>
>   
Mdadm has no need to know or care about file systems.  It exists on the 
hardware, /dev level, upon which file systems, if any, are built.

b-

