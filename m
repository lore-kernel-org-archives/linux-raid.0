From: "Catalin(ux aka Dino) BOIE" <util@deuroconsult.ro>
Subject: Re: Is there any way to delay reconstruction
Date: Wed, 25 May 2005 09:26:27 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0505250925360.6360@webhosting.rdsbv.ro>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 May 2005 danci@agenda.si wrote:

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
> Thanks, Danilo

You can hot-remove the previous failed disk (anyway, it just started to 
resync). Then, activate DMA, then hot-add the disk to array.

Hope it helps.

---
Catalin(ux aka Dino) BOIE
catab at deuroconsult.ro
http://kernel.umbrella.ro/
