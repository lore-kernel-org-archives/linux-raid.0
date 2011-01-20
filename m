From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Moving existing RAID5 disks to an alternate server
Date: Thu, 20 Jan 2011 10:28:42 +0000
Message-ID: <4D380E5A.7030601@anonymous.org.uk>
References: <AANLkTim4xsHXxBERJf0qucYgAizmzB8__66RR3XnT081@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim4xsHXxBERJf0qucYgAizmzB8__66RR3XnT081@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Powell <powellj@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/01/2011 03:05, John Powell wrote:
[...]
> Anyhow, the point of my post: Is it really as simple as it sounds? Use
> mdadm to recreate the RAID5 volume and away I go? Are there any
> details that one can offer that I may need to be aware of or is simply
> reading the man pages and various HOWTO's out on the net enough to get
> started? Obviously I am taking this slow as the data on the disks is
> important to me.

Well, you might be really lucky and find that a few mdadm --examine 
commands give you all you need to know, or even that whatever distro you 
run auto-detects and starts your array, but given that the data is 
valuable, I'd recommend making images of the discs and working with 
those instead.

First up, use smartctl to check the drives don't have bad sectors. If 
they do, and perhaps even if they don't, ddrescue or dd_rescue is your 
friend (I don't know which is better).

Then, if you have another 4 drives of exactly the same size, that's 
perfect, but you probably don't. If your PATA drives are relatively 
small, you might be as well dd'ing or dd_rescuing all four drives to 
images on a new larger SATA drive, then mounting the images via loopback 
devices.

If you have trouble reading any of the drives for any reason, you might 
make a backup copy of the image before starting to test it, or look at 
some previous ideas on this list about making Copy-on-Write devices on 
top of your loopback devices. This may be paranoia but may be worth 
reading about, just to give you the option.

Then you can start poking the images with mdadm, dmraid, and perhaps 
kpartx to activate any partitions, and report back as Neil suggested in 
his post.

Best of luck.

Cheers,

John.

