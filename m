From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 11:59:35 -0500
Message-ID: <20090821165935.GA18915@sewage>
References: <20090820163522.GA29215@sewage> <4A8D99D9.2090806@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A8D99D9.2090806@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 21, 2009 at 06:45:45AM +1200, Richard Scobie wrote:
> Matt Garman wrote:
>> So what I'm trying to figure out is, what is causing the disk
>> access?  It could be any one of:
>>
>>     - Kernel
>>     - RAID subsystem (i.e. md)
>>     - XFS filesystem
>>     - NFS
>>     - Samba
>>     - ???
>
> Are you running smartd? It polls the drives every 30minutes.

I was running smartd, until I received your post :)

Unfortunately, this does not help keep the heads parked any longer.

Nonetheless, thank you for the hint.

Matt

