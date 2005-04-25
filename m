From: Gil <gil@fooplanet.com>
Subject: Re: raid 10 or 1+0 ?
Date: Mon, 25 Apr 2005 13:26:58 -0700
Message-ID: <426D5292.4080007@fooplanet.com>
References: <E3B0B2160F552B408D3655883F58C14490CC@cinshrexc02.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E3B0B2160F552B408D3655883F58C14490CC@cinshrexc02.shermfin.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Rechenberg Lists <flux-ml@sfg.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Rechenberg Lists wrote:
> I've never seen nor tried a "/" file system on RAID10 or RAID0+1. 
> What I usually hear recommended is /boot and or / on RAID1 and then 
> if you need better performance for a database or other application, 
> then create a /data partition or something of the sort on a separate 
> RAID10 array that is on different disk spindles.

Having a RAID1 root partition is fantastic because even if you totally
flub your RAID setup elsewhere you can still boot the system without
being RAID aware.  This is a huge advantage over either RAID10 or
RAID0+1 in my mind.

--Gil
