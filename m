From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Creating a RAID10 (near) for use in a CentOS 6 system
Date: Mon, 25 Mar 2013 19:05:24 -0600
Message-ID: <CD18173A-4AED-46CA-AC32-4ABAD918BDBD@colorremedies.com>
References: <515089B1.9010607@gmail.com> <51509025.2060402@gmail.com> <CC7A8866-EC41-48C7-9E92-25AE51E61D67@colorremedies.com> <5150DC08.8000702@gmail.com> <4C0D23B0-8ABA-4086-BF42-774EF7F0C817@colorremedies.com> <5150E665.2090902@gmail.com> <843EA420-6F4A-41DF-BDED-7F35D6263A87@colorremedies.com> <5150F00E.4060506@harddata.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5150F00E.4060506@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 25, 2013, at 6:47 PM, Maurice Hilarius <maurice@harddata.com> wrote:

> On 3/25/2013 6:40 PM, Chris Murphy wrote:
>> On Mar 25, 2013, at 6:05 PM, maurice <mhilarius@gmail.com> wrote:
>>> What about partitioning the drives first, installing a smallish partition for boot, then a second much larger partition on each for the RAID10?
>> What's the advantage of this compared to a separate drive? In your proposed scenario, if the /boot drive dies, you have an unbootable system anyway.
> Firstly, there would be 4 redundant copies of the boot.

AFAIK you'll have to make those 4 copies yourself, the installer won't do it unless you use kickstart, and it won't partition the drives correctly for it. And you'll have to keep them sync'd. And you'll have to manually install grub to all four disks, as the installer will only install to one disk.

> Secondly, there is only room for 4 drives in this chassis.

USB stick, ext2 to avoid journal wear. And only put boot on it. rootfs can go on the array. And you can setup a swapfile to go in rootfs instead of a swap partition.

> 
> In reading the man pages, it seems near 2 is the default option for create?
> 
> Is there any reason to be wary of the stock CentOS 6 2.6.32 kernel?

No idea. I'd probably use a newer one from EL repo, and keep the 6.4 kernel handy as a fallback which I think is now 2.6.32.358.


Chris Murphy