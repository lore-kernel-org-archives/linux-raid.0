From: David Brown <david.brown@hesbynett.no>
Subject: Re: Issue with md and 4K sector alignment
Date: Mon, 20 Aug 2012 09:28:43 +0200
Message-ID: <5031E72B.8060002@hesbynett.no>
References: <5031556B.5050706@averageurl.com> <alpine.DEB.2.00.1208200735020.27104@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1208200735020.27104@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Kyle Brantley <kyle@averageurl.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/08/2012 07:36, Mikael Abrahamsson wrote:
> On Sun, 19 Aug 2012, Kyle Brantley wrote:
>
>> I understand that I may need to work on the higher layers (LVM,
>> partitioning -- and if there is any insight here, it would be
>> appreciated!) with respect to the alignment, but my concern is the
>> resync times. I've tried building the array off of both the raw disks
>> and 4K aligned partitions placed on the disks -- the resync
>> performance is identical, and poor.
>
> If you create the md directly on the device instead of doing partitions,
> you don't have to worry. LVM and md are already 4k aligned.
>
> If you create partitions, then you have to make sure they're 4k aligned.
>

It would be nice if LVM and md moved towards a bigger native alignment. 
  4K is good enough for hard disks, but for SSD's you want to align 
partitions on erase block boundaries.  The standard used by modern fdisk 
and gparted (and tools from the-OS-that-must-not-be-named) is 1 MB - a 
bigger alignment than is necessary for current SSDs, but one that will 
be good enough for the foreseeable future.

