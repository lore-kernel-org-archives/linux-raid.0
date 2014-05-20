From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: evacuating drives in a RAID10 array
Date: Tue, 20 May 2014 03:25:20 -0500
Message-ID: <537B1170.3090100@hardwarefreak.com>
References: <CAN7CiWh6rR-iT6Bicqpt-R4ohVJwg_6sTzA8eQnajAP-5-Rd=g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN7CiWh6rR-iT6Bicqpt-R4ohVJwg_6sTzA8eQnajAP-5-Rd=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Carmula <bryancarmula@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/19/2014 11:22 PM, Bryan Carmula wrote:
> Hi all,
> 
> Can anyone provide insight (or point toward appropriate documentation)
> on how to evacuate/decommission a drive that is a member of a complex
> (non-nested) RAID10 array while keeping data intact? Number of
> replicas can be reduced to 1 if necessary; this is a temporary state
> as part of a data migration.
> 
> $ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid10 sdd1[2] sde1[3] sda1[0] sdc1[1]
>       3907023872 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>       bitmap: 0/233 pages [0KB], 8192KB chunk

This help request is quite sparse on detail and may limit the number of
folks willing/able to jump in.  You may wish to provide more detail as
to what you're attempting to accomplish in order to widen the field.

Cheers,

Stan
