From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Problems with a RAID5 array
Date: Tue, 25 Oct 2016 19:54:03 +0200
Message-ID: <20161025175403.GA18860@metamorpher.de>
References: <5C95474C-8A2A-4472-9629-2DD6B2143D28@GMAIL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5C95474C-8A2A-4472-9629-2DD6B2143D28@GMAIL.COM>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Nicolaou <nicolaoun@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 25, 2016 at 10:45:12AM +0300, Nicolas Nicolaou wrote:
> Below you can see the mdadm —examine information for the 4 drives. 

The output doesn't seem to be formatted correctly, hard to read.
Also you posted only 2 of 4 disks, for two different RAIDs,
with different metadata (1.0 vs. 0.90), creation times...

Basically this is too confusing to say anything about it.

Did you pick the correct devices?

> /dev/sda3:
> Magic : a92b4efc
> Version : 1.0
> Array UUID : 11d32674:4247f385:74ee352b:5e4c22c7
> Creation Time : Wed Jan 9 02:29:02 2013
> Raid Level : raid5
> Raid Devices : 4

> /dev/sdb3:
> Magic : a92b4efc
> Version : 00.90.00
> UUID : 3fe6d5d4:5b9d61f2:4f7ddb81:e4ae2138
> Creation Time : Thu Jun 7 19:50:56 2012
> Raid Level : raid5

Regards
Andreas Klauer
