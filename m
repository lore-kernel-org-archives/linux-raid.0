From: Jeff Hoffmann <jhoffman@microelectronics.com>
Subject: Re: RAID 0 -> 1 possible?
Date: Fri, 12 Mar 2004 14:31:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40520FFD.1010702@microcenter.com>
References: <4050CF9C.6000704@microcenter.com> <4051503E.6090703@tequila.co.jp> <4051CCBF.2020108@microcenter.com> <4051D738.309CB8FE@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4051D738.309CB8FE@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/12/04 10:28, Paul Clements wrote:
> Well, in that case you just might be able to do it. You'll need to
> shrink your filesystem (if you have one) ala resize2fs or similar. Then
> raidreconf the raid0. Then edit the partition table (there are tools to
> help with this, or just use fdisk very carefully) to shrink the
> partition. Then you can create a new partition and dump the data there.
> Create another similarly sized partition and raid1 them together...

That seems like it would work, but I thought raidreconf was used for adding 
disks to arrays, not making them smaller.  How do you use raidreconf in this manner?

Thanks for your help,

Jeff Hoffmann

