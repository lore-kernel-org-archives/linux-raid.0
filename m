From: Simen Thoresen <simentt@dolphinics.no>
Subject: Re: Grub vs Lilo
Date: Thu, 27 Jul 2006 13:50:38 +0200
Message-ID: <44C8A88E.4020600@dolphinics.no>
References: <200607272316.23441.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607272316.23441.mylists@blue-matrix.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lewis Shobbrook <mylists@blue-matrix.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lewis Shobbrook wrote:
> Hi All,
> 
> Wondering if anyone can comment on an easy way to get grub to update all 
> components in a raid1 array.  I have a raid1 /boot with a raid10 /root and 
> have previously used lilo with the raid-extra-boot option to install to boot 
> sectors of all component devices.  With grub it appears that you can only 
> update non default devices via the command line.  I like the ability to be 
> able to type lilo and have all updated in one hit.  Is there a way to do this 
> with grub?  

Hi All,

I'll second this RFI - I /think/ I know how to set this up by hand (I'm 
following the doc on 
http://www.ex-parrot.com/~pete/software-raid-howto.html
, and have tested booting from each drive from this), but this is 
neither very simple, nor automatically applied to a new disk when it is 
hot-added. Thus the procedure will need to be executed each time a drive 
is replaced.

Perhaps a GRUB-forum is a better venue for this discussion?

-S


> Cheers,
> 
> Lewis
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Simen Thoresen, Dolphin ICS
Systems Administration and Wulfkit Support
