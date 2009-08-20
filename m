From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 06:45:45 +1200
Message-ID: <4A8D99D9.2090806@sauce.co.nz>
References: <20090820163522.GA29215@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090820163522.GA29215@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:

> So what I'm trying to figure out is, what is causing the disk
> access?  It could be any one of:
> 
>     - Kernel
>     - RAID subsystem (i.e. md)
>     - XFS filesystem
>     - NFS
>     - Samba
>     - ???

Are you running smartd? It polls the drives every 30minutes.

Regards,

Richard
