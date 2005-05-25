From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Is there any way to delay reconstruction
Date: Wed, 25 May 2005 08:09:05 -0700
Message-ID: <42949511.3@nsr500.net>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Recompile with piix in the kernel.

danci@agenda.si wrote:
> Hi,
> 
> I have 800+ machines all using Linux SW RAID-1. Recent kernels use modules 
> for IDE (piix) and before those modules are loaded, I cannot turn on DMA. 
> So I do this using hdparm from a rc.boot script. 
> 
> The problem is that usually fails with 'hdX: lost interrupt' if the disks 
> are busy due to RAID reconstruction - which happens a lot as some of the 
> 800+ machines get rebooted for various reasons...
> 
> Of course I could be running without DMA (that's what I did on most 
> critical machines), but that is painfully slow and it takes forever just 
> to finish RAID reconstruction.
> 
> So I need to know if there is any way (kernel parameter would be ideal) to 
> delay reconstruction for X seconds/minutes?
> 
> Any other suggestions to deal with the problem?
> 
>  Thanks, Danilo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

