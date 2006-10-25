From: Chase Venters <chase.venters@clientec.com>
Subject: Re: Bug with RAID1 hot spares?
Date: Tue, 24 Oct 2006 23:43:51 -0500
Message-ID: <200610242344.13576.chase.venters@clientec.com>
References: <200610202046.43033.chase.venters@clientec.com> <453EC0C4.2040006@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453EC0C4.2040006@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, jason.meinzer@gmail.com
List-Id: linux-raid.ids

On Tuesday 24 October 2006 20:41, Bill Davidsen wrote:
> Chase Venters wrote:
> >Greetings,
> >	I was just testing a server I was about to send into production on kernel
> >2.6.18.1. The server has three SCSI disks with "md1" set to a RAID1 with 2
> >mirrors and 1 spare.
>
> I have to ask, why? If the array is mostly written you might save a bit
> of bus time, but for reads having another copy of the data to read
> (usually) helps the performance by reducing wait for read occurences.

The main idea is to not exercise the spare as much as the other disks. All 
three disks are from the same lot. Having three disks fail at once is 
admittedly unlikely, but keeping one disk as a spare rather than full mirror 
should probably reduce the wear on that disk so if there is some 
manufacturing defect the third drive wouldn't be as close to failing and 
could hopefully keep the box online until someone makes it to the datacenter 
to do a swap.

Thanks,
Chase
