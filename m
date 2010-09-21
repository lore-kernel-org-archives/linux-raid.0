From: Tim Small <tim@seoss.co.uk>
Subject: Re: Debian kernel stanza after aptitude kernel upgrade
Date: Tue, 21 Sep 2010 17:06:50 +0100
Message-ID: <4C98D81A.3080309@seoss.co.uk>
References: <30D96C04B1444C569D53B7790707D718@DesktopManie> <4C98CCCD.80101@seoss.co.uk> <1D98EFF18F1D408AB045D3B47BE01685@DesktopManie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1D98EFF18F1D408AB045D3B47BE01685@DesktopManie>
Sender: linux-raid-owner@vger.kernel.org
To: "A. Krijgsman" <a.krijgsman@draftsman.nl>, "linux-raid@vger.kernel.org >> \"linux-raid@vger.kernel.org\"" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/09/10 16:52, A. Krijgsman wrote:
> However debian apt-get updated the kernel image, and I assume that 
> process ran update-initramfs because of that.

This is getting a bit OT, but yes, a new kernel install will normally 
trigger an update to the initramfs files, however this can be disabled.  
See /etc/initramfs-tools/ and the contents of the debconf database...


> I will also look into grub2 as well,!

Personally, I think I'd stick with grub1 on lenny, but use that 
workaround - that's what I do, and it only needs to be done when 
adding/replacing disks etc.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

