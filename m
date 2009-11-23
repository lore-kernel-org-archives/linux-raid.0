From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: RAID, ext4, barriers
Date: Mon, 23 Nov 2009 11:29:59 -0500
Message-ID: <4B0AB887.3040801@redhat.com>
References: <4AF6F975.8030903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6F975.8030903@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/08/2009 12:01 PM, Andrew Dunn wrote:
> I noticed this in my dmesg:
>
> [ 7089.116953] JBD: barrier-based sync failed on md0:8 - disabling barriers
> [ 9296.850098] JBD: barrier-based sync failed on md1:8 - disabling barriers
>
> I was wondering if this is a problem. I saw some links where people were
> listing this as a bug report for ext[2,3,4] partitions. I don't know if
> it will be a problem for me, any experience?
>
>    

Hi Andrew,

If you are worried about losing power on this RAID set, you need to make 
sure that the write cache on the individual drives is disabled. Without 
barriers, you can bet that the file system will lose data after a power hit.

Note that not all MD raid levels support barriers, although I think that 
Neil posted some patches that tried to close that gap,

Ric

