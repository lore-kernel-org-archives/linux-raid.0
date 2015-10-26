From: Phil Turmel <philip@turmel.org>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Mon, 26 Oct 2015 10:10:37 -0400
Message-ID: <562E345D.5030206@turmel.org>
References: <562D8142.80507@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562D8142.80507@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Adam,

On 10/25/2015 09:26 PM, Adam Goryachev wrote:
> Hi all,
> 
> I'm trying to convert a 4 disk RAID10 to a RAID5. Currently I have:
> cat /proc/mdstat
> Personalities : [raid10]
> md0 : active raid10 sdd1[2] sdc1[1] sdb1[0] sde1[3]
>       7813772288 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>       bitmap: 0/59 pages [0KB], 65536KB chunk

[trim /]

Your plan looks reasonable, if a bit long.  I've done similar before.
Usually I add the new array to the LVM volume group of the original,
then pvmove the contents to the new physical volume.  Let's me stay
online through the entire operation.

Anyways, it seems you are missing an opportunity to convert in place,
though.  Consider setting up four small loop devices and test
conversions from r10,n2 -n4 => r0 -n3 => r4 -n4 => r5 -n4 .  I suspect
you can get to your new raid5 without moving a bunch of data around.

Phil
