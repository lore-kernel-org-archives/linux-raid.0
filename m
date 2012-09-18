From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported through LIO (iSCSI)
Date: Tue, 18 Sep 2012 10:48:01 -0600
Message-ID: <F60117AF-A6B1-473D-AE1D-0AF1DA373A6E@colorremedies.com>
References: <50588731.5050502@bananateam.nl>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50588731.5050502@bananateam.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 18, 2012, at 8:37 AM, Ferry wrote:

> As I'm not sure where to go, I've
> sent this to both linux-raid and target-devel lists.


I think you're better off taking a chance with one, waiting a few days, then going with another, rather than crossposting.


> So for example I see disk <sdX> do 600-700kB/s reading in I/O stat
> whilst it's writing about 100kB/s.

You've provided no information on the hardware being used, version of kernel and mdadm, or info on the array such as mdadm -Evv <array>.


> With msdos partitions I could easily mess with it myself. GPT however
> also has mirror headers and those might actually overwrite my data if
> done incorrectly. At least - that's what I'm worried about, not sure if
> that theory is solid.

GPT contains checksums for the header and table, so you can't just make manual table edits. And there's no need, just use gdisk (a.k.a. GPT fdisk) or sgdisk.

> Also, with msdos I could easily make backups with
> dd or sfdisk (of the partition table). Not aware of such a tool for gpt.
> Parted doesn't seem to be able to dump them.

gdisk (interactive) or sgdisk (command line) can do this.

Chris Murphy