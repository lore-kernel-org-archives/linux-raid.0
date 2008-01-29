From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 12:14:51 +0100
Message-ID: <479F0AAB.3090702@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F07E1.7060408@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> 
> One of the puzzling things about this is that I conceive of RAID10 as 
> two RAID1 pairs, with RAID0 on top of to join them into a large drive. 
> However, when I use --level=10  to create my md drive, I cannot find out 
> which two pairs are the RAID1's: the --detail doesn't give that 
> information. Re-reading the md(4) man page, I think I'm badly mistaken 
> about RAID10.
> 
> Furthermore, since grub cannot find the /boot on the md drive, I deduce 
> that RAID10 isn't what the 'net descriptions say it is.
> 

It is exactly what the names implies - a new kind of RAID :) The setup you 
describe is not RAID10 it is RAID1+0. As far as how linux RAID10 works - here 
is an excellent article: 
http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

Peter
