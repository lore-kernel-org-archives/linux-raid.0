From: Jeff Garzik <jeff@garzik.org>
Subject: Linux: Why software RAID?
Date: Wed, 23 Aug 2006 23:34:25 -0400
Message-ID: <44ED1E41.40606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

Mark Perkel wrote:
> Running Linux on an AMD AM2 nVidia chip ser that supports Raid 0
> striping on the motherboard. Just wondering if hardware raid (SATA2) is
> going to be faster that software raid and why? 


First, it sounds like you are confusing motherboard "RAID" with real 
RAID.  There's a FAQ for this sort of thing:

	http://linux-ata.org/faq-sata-raid.html

In particular, your motherboard's Raid 0 striping (a) is not done in 
hardware, and (b) has nothing to do with SATA2.

But anyway, to help answer the question of hardware vs. software RAID, I 
wrote up a page:

	http://linux.yyz.us/why-software-raid.html

Generally, you want software RAID unless your PCI bus (or more rarely, 
your CPU) is getting saturated.  With RAID-0, there is no duplication of 
data, and so, PCI bus and CPU usage should be about the same for 
hardware and software RAID.

	Jeff


