From: "J. Ryan Earl" <heretic@clanhk.org>
Subject: Re: libata and md issues with 2.9.1-rc1
Date: Tue, 24 Aug 2004 17:31:32 -0500
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <412BC1C4.2060506@clanhk.org>
References: <412B79DF.2000705@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <412B79DF.2000705@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-ide@vger.kernel.org, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brad Campbell wrote:

> Just a heads up. I'm experiencing "issues" with 2.6.9-rc1 that don't 
> occur with 2.6.5.
>
> I run a 10 disk raid-5 on 3xPromise SATA150 cards and a 2 disk raid-0 
> on the on-board VIA chipset.
> The 10 disks are Maxtor Maxline-II SATA drives and the raid-0 is a 
> pair of WD2000JB drives with
> Addonics SATA->PATA converters. 

Did you try RAID-0 with the pair of Western Digital drives on the two 
free Promise slots?  If that fails similarly, it might not be a libata 
issue.

-ryan
