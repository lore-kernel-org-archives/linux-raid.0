From: Chris Murphy <lists@colorremedies.com>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having alive mirrors?
Date: Thu, 14 Mar 2013 21:43:14 -0600
Message-ID: <FCBB3555-81D9-4C7E-87D5-9AFBE20ED529@colorremedies.com>
References: <20130315041054.79eb5dcc@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130315041054.79eb5dcc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 14, 2013, at 4:10 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> 
> - shouldn't the reads have been quietly satisfied my md3 from sdf1, instead of just passing the buck^W error
>  due to unreadable sdg1 to the higher (filesystem) layer?

What distro kernel and version?

Since you're not using btrfs raid1 there isn't a second copy maintained by btrfs itself, so it can't fix this. It's reporting a checksum failure for the single copy of data on the md raid1. It is getting the data elsewhere but it's btrfs saying that the checksum doesn't match.

Chris Murphy

