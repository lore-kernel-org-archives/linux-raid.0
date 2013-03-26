From: maurice <mhilarius@gmail.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 18:05:57 -0600
Message-ID: <5150E665.2090902@gmail.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/25/2013 5:44 PM, Chris Murphy wrote:
> ..Oh that's a totally different scenario.
> I thought you wanted the raid10 array for /home or /data or whatever.
> That's pretty messy, actually, even on Fedora 18/19 which has the 
> benefit of a new anaconda and GRUB2.
> GRUB2 definitely can assemble md raid10, and read most any file 
> system, find /boot, and load the kernel and initramfs.
> That's not something I think GRUB Legacy can do, which is what CentOS 
> 6 is using.
>
> ..
>
> I'm unsure of your use case, but I'm thinking you may be better off 
> with a small SSD for the boot, swap and system disk,
> and then use a separate raid10 array for /home, /opt, /data, whatever 
> else you want.
> Otherwise it's a bit of a rabbit hole.
>
Fair enough then.

What about partitioning the drives first, installing a smallish 
partition for boot, then a second much larger partition on each for the 
RAID10?
Do you think that the CentOS installer and GRUB would have any issues 
with that layout?


Thanks Chris.

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
