From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 18:40:00 -0600
Message-ID: <843EA420-6F4A-41DF-BDED-7F35D6263A87@colorremedies.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com> <5150E665.2090902@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5150E665.2090902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 25, 2013, at 6:05 PM, maurice <mhilarius@gmail.com> wrote:
> 
> What about partitioning the drives first, installing a smallish partition for boot, then a second much larger partition on each for the RAID10?

What's the advantage of this compared to a separate drive? In your proposed scenario, if the /boot drive dies, you have an unbootable system anyway. 

> Do you think that the CentOS installer and GRUB would have any issues with that layout?

No. It'll be fine with that. It does partition drives though, not arrays.


Chris Murphy