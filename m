From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Wed, 18 Feb 2004 17:58:23 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4033EE0F.5090206@pobox.com>
References: <20040218214840.GS20790@datavibe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040218214840.GS20790@datavibe.net>
To: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rev. Jeffrey Paul wrote:
> I'm building an nfs server to export home directories to a few login 
> servers used somewhat heavily by a few hundred people.  Additionally, on 
> the array will be a bunch of web content and mysql data files.
> 
> I'm currently thinking of a few different configurations, all using four
> drives in the 180-250gb range.  I could get sata or udma drives, i could
> go raid5 or raid10, and i could do this in linux software raid (using,
> say, a pair of promise ultra100s to give me four udma ports, or with an
> SATA card), using 3ware's UDMA four-port escalade, or with 3ware's new
> sata escalade.


3ware hardware is really nice, so that would be a good choice.

But...  I am a bit biased:  I almost always prefer software RAID over 
hardware RAID.  Much more flexibility to move disks between systems, 
choose controller(s) you like, etc.

In theory performance of hardware RAID can be better than software RAID. 
  In practice, only a few hardware RAID controllers actually achieve this.

	Jeff



