From: Colin McDonald <ce.mcdonald@gmail.com>
Subject: Re: hostRAID, AIC-7901, disable?
Date: Mon, 13 Dec 2004 16:09:58 -0500
Message-ID: <bbfa52890412131309234b2d09@mail.gmail.com>
References: <cpkem3$70s$1@sea.gmane.org>
Reply-To: Colin McDonald <ce.mcdonald@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cpkem3$70s$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: murray evans <m.evans@rdg.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cntl+A into the SCSI bios & disable it. 

Try that. 




On Mon, 13 Dec 2004 16:04:08 +0000, murray evans <m.evans@rdg.ac.uk> wrote:
> We have recently aquired a new Dell Precision 670 workstation, on which
> we intended to install linux, (Suse 9.1).
> In the install, is reports it can not find any hard drives.
> We think we have tracked this problem down to the AIC-7901 hostRAID
> SCSI controller. From what I we can gather, linux no longer has
> drivers for hostRAID hardware. We don't care about having RAID, just
> a working system, so we would be content to simply disable the
> hostRAID. the problem is, the setup tool does not have any option
> to disable hostRAID.
> 
> Has anyone come across a solution? Is there a driver I don't know of?
> Is there a way of disabling hostRAID?
> 
> *PS: From the SuSe install, when we try to add the appropriate SCSI
> module for the AIC-7901, it fails.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
