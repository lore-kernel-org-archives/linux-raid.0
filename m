From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Wed, 11 Nov 2009 11:51:08 -0700
Message-ID: <200911111151.09021.tfjellstrom@shaw.ca>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com> <200911110004.31238.tfjellstrom@shaw.ca> <4AFAFC75.3070307@sauce.co.nz>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFAFC75.3070307@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed November 11 2009, Richard Scobie wrote:
> Thomas Fjellstrom wrote:
> > Thats the problem he was trying to get away from. the MV8 controller
> > likes to offline disks when a few smart commands arrive. at least with
> > the main kernel drivers. But then the main kernel mvsas drivers decide
> > to give up if you even attempt to start a raid array on them. The
> > controller locks up and you have to reboot. Most of the time a reboot
> > even fails when it tries to sync the block devices, so a hard reset is
> > in order.
> 
> OK, I did not know the Marvell controller also has a problem with
> smartmontools.

Given the state of the in kernel drivers, its probably a driver issue.

> In his original post he mentions it having problems with mdadm:
> 
> "(mdadm freaks out on it and the controller drops the drives - there has
> been discussion of the problem on the list. Seems to be a mvsas driver
> problem but seems to surface only under mdadm use.)"
> 
> Regards,
> 
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
