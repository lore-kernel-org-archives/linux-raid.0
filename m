From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: very strange (maybe) raid1 testing results
Date: Thu, 31 May 2007 14:35:23 +1200
Message-ID: <465E346B.7090701@sauce.co.nz>
References: <Pine.LNX.4.64.0705292135200.4266@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705292135200.4266@gheavc.wnzcbav.cig>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson wrote:

> I am getting 70-80MB/s read rates as reported via dstat, and 60-80MB/s 
> as reported by dd. What I don't understand is why just one disk is being 
> used here, instead of two or more. I tried different versions of 
> metadata, and using a bitmap makes no difference. I created the array 
> with (allowing for variations of bitmap and metadata version):

This is normal for md RAID1. What you should find is that for concurrent 
reads, each read will be serviced by a different disk, until no. of 
reads = no. of drives.

Regards,

Richard
