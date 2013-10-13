From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Sun, 13 Oct 2013 18:44:48 +0200
Message-ID: <525ACE00.8090105@arcor.de>
References: <5253F7C2.2030401@pobox.com> <52541473.4020005@pobox.com> <52545092.1040001@arcor.de> <5257F706.8050708@pobox.com> <52583FC1.1070107@arcor.de> <52585642.6000005@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52585642.6000005@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <b.candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/11/2013 09:49 PM, Brian Candler wrote:
>  > Maybe, but your setup is pretty unusual. These MD arrays are "disks" 
> for the installer, and thus would need to be partitioned. I believe it 
> would work better that way. I have never tried an LVM PV on a whole disk.
> 
> It wouldn't let me partition md125 either. It just did nothing when I 
> clicked "Edit".

I assume that that has something to do with the pre-exisiting PV. But
that's just a guess. I have successfully installed CentOS on BIOS RAID
on several occasions. In any case, what you describe is "just" an
anaconda problem. Annoying of course, but you should get in touch with
anaconda people to solve it.

Martin

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

