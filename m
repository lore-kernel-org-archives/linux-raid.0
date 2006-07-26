From: Jason Lunz <lunz@falooley.org>
Subject: Re: Grub vs Lilo
Date: Wed, 26 Jul 2006 16:44:42 +0000 (UTC)
Message-ID: <ea865p$7o0$1@sea.gmane.org>
References: <200607261943.24828.mylists@blue-matrix.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mylists@blue-matrix.org said:
> Wondering if anyone can comment on an easy way to get grub to update
> all components in a raid1 array.  I have a raid1 /boot with a raid10
> /root and have previously used lilo with the raid-extra-boot option to
> install to boot sectors of all component devices.  With grub it
> appears that you can only update non default devices via the command
> line.  I like the ability to be able to type lilo and have all updated
> in one hit.  Is there a way to do this with grub?  

assuming your /boot is made of hda1 and hdc1:

grub-install /dev/hda1
grub-install /dev/hdc1

Jason

