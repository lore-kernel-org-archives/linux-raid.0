From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Thu, 6 Jan 2005 18:08:23 +0100
Message-ID: <200501061808.23813.maarten@ultratux.net>
References: <200501061646.j06Gkm931902@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501061646.j06Gkm931902@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 06 January 2005 17:46, Guy wrote:
> This is from "man mdadm":

Oops. really ?  Sorry, I should have checked that myself.  Mea culpa.

> As  well  as  reporting  events,  mdadm may move a spare drive from one
> array to another if they are in the same spare-group and if the  desti-
> nation array has a failed drive but not spares.
>
> You can do what you want.  I have never tried.  My arrays are too
> different. I don't want to waste an 18Gig spare on a 256M array.

Same (but different) idea here, I'd hate to waste a 250GB for a spare. :-)

I still have one LVM issue to figure out, they say that you should set the 
partition type to 0x8e, but I can't find if that applies to md devices too. 
And if it does how do you set that. Running 'fdisk /dev/mdx' ?  Well, why not 
I suppose, but I've never ran fdisk on an md device, only mkfs.*

Thanks Guy,
Maarten

-- 


