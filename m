From: Jeff Hoffmann <jhoffman@microelectronics.com>
Subject: Re: RAID 0 -> 1 possible?
Date: Fri, 12 Mar 2004 09:44:15 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4051CCBF.2020108@microcenter.com>
References: <4050CF9C.6000704@microcenter.com> <4051503E.6090703@tequila.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4051503E.6090703@tequila.co.jp>
To: Clemens Schwaighofer <cs@tequila.co.jp>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 03/12/04 00:53, Clemens Schwaighofer wrote:

> | Convert / from RAID 0 to 1 without requiring a backup/reinstall/restore
> | scenario
> |
> | Any RAID-mojo-masters with the answer?
> 
> I think that can't work unless you add two more disks. Raid 0 is strip
> where 1 is mirroring.

Indeed.  In my case, the data actually on the partition is < 25%.  Perhaps 
there's a way to shrink the RAID 0 set?  That would allow a new partition (not 
striped) to be created to store the data.

Thanks for your input,

Jeff Hoffmann
