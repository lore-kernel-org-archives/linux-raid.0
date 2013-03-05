From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: help with degraded raid1 array
Date: Tue, 5 Mar 2013 06:03:01 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303050559560.14991@uplift.swm.pp.se>
References: <kh2ukl$o1s$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kh2ukl$o1s$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Mar 2013, scar wrote:

> looks like there are problems with both my disks? (ata3 and ata4)

You're getting ABRT and DRDY. Use smartctl to verify that you don't have 
any "pending" or "offline_uncorrectable" sectors on the drives. If they 
are 0, then most likely it's a controller or cabling issue.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
