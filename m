From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 08:51:20 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040210085120.A22710@lists.us.dell.com>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>; from thomas@horsten.com on Tue, Feb 10, 2004 at 02:18:15PM +0000
To: Thomas Horsten <thomas@horsten.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 10, 2004 at 02:18:15PM +0000, Thomas Horsten wrote:
> - After I have used the DM (and possible MD for some RAID types) to map
> the ataraid devices, is there a way to remove the partitions from the
> underlying disks from the kernel?
> Detecting the partition table in userspace would fix this, but it's not
> planned before 2.7 and I don't think it is safe to leave the false
> partitions exposed.

partx, part of util-linux, can do this in userspace today.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
