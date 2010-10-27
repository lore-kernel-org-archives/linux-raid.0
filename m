From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Subject: Re: MD RAID1 deadlock on failed disk
Date: Wed, 27 Oct 2010 00:18:25 GMT
Message-ID: <0AFDQ6P11@briare1.fullpliant.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2.6.32.24 kernel worked fine.

Hubert Tonneau wrote:
>
> Hi,
> 
> The configuration is:
> Perc H200 controler configured with no RAID (mpt2sas driver),
> 2 SATA disks (sda and sdb),
> Linux MD Sofware RAID1 (md0),
> stock Linux 2.6.35.7 kernel.
> 
> I hotunplug the second (sdb) disk, and the result is:
> . as expected, I can read sda device,
> . as expected, any read to sdb device fails,
> . unexpectedly, and read to md0 never returns.
> 
> No oops or thing like that in the kernel log.
> I did not try the same with other kernel releases.
> 
> Regards,
> Hubert Tonneau

