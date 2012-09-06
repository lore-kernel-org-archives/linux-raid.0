From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Issue with md and 4K sector alignment
Date: Thu, 06 Sep 2012 13:34:20 -0700
Message-ID: <504908CC.2030400@zytor.com>
References: <5031556B.5050706@averageurl.com> <alpine.DEB.2.00.1208200735020.27104@uplift.swm.pp.se> <5031E72B.8060002@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5031E72B.8060002@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Kyle Brantley <kyle@averageurl.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/20/2012 12:28 AM, David Brown wrote:
>
> It would be nice if LVM and md moved towards a bigger native alignment.
>   4K is good enough for hard disks, but for SSD's you want to align
> partitions on erase block boundaries.  The standard used by modern fdisk
> and gparted (and tools from the-OS-that-must-not-be-named) is 1 MB - a
> bigger alignment than is necessary for current SSDs, but one that will
> be good enough for the foreseeable future.
>

This is one advantage with superblock 1.0 -- the alignment of the 
underlying device is preserved since the metadata is at the end.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

