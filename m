From: Gregory Leblanc <gleblanc@cu-portland.edu>
Subject: Re: Old Bug?
Date: 19 Aug 2002 17:10:32 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <993361055.1072.0.camel@peecee.linuxweasel.com>
References: <01062303045500.00923@exodus>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01062303045500.00923@exodus>
To: iain@sandon.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Jun 2001 03:04:55 -0400, Iain Campbell wrote:
> Scenario:
> 
> 1. Simple 2 disk RAID1
> 2. Disk 0 fails
> 3. Bring machine down and replace disk (same SCSI id as old one)
> 4. Boot hangs on raidstart with "/dev/md1: invalid argument" error

Do you have the partitions set to type 'fd', and thus are using the RAID
autostart code?
	Greg

