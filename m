From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Grub vs Lilo
Date: Wed, 26 Jul 2006 14:40:11 +0400
Message-ID: <44C7468B.4070500@tls.msk.ru>
References: <200607261943.24828.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607261943.24828.mylists@blue-matrix.org>
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

You only need to update stuff for grub once - when installing it.
And during installation, it's ok to run it multiple times, once for
each component device - not a big deal really.  Just like you will
partition your disks and install an MBR - once for each disk.

After installation, grub does not need to modify boot records - only
/boot/grub/menu.lst (whatever) file is updated to reflect your kernels,
and this is a normal file (grub will find it by its own, by properly
reading the filesystem).

/mjt
