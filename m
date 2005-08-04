From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Setup a Raid while OS is running
Date: Thu, 4 Aug 2005 19:52:04 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0508041948000.20853@lion.drogon.net>
References: <47670.212.34.68.2.1123168858.squirrel@extern.x-cellent.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47670.212.34.68.2.1123168858.squirrel@extern.x-cellent.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 4 Aug 2005, Stefan Majer wrote:

> Hi,
>
> i have a server running on only one scsi disk. I got now one scsi disk
> extra and i want to transform the actual installation to use both disks in
> a raid1.
> Therefore i want to mirror each partition with md.
> The Question now is how to do that, if possible, without destroing the
> installed OS.
>
> I thought it should be possible to do it in the following way:
>
> 1. create the same partitions on the secondary drive

sfdisk -d /dev/sda > /tmp/sda.part
sfdisk /dev/sdb < /tmp/sda.part


> 2. create a mirror for each partition with the actual installed partition
> marked as "missing"

At this point, go & read the Software RAID-HowTo, and look for the
Root-RAID section.

Gordon
