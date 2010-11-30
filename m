From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Problems after reshaping of Raid5 array
Date: Tue, 30 Nov 2010 18:00:54 +0100
Message-ID: <4CF52DC6.4020606@computer.org>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>	 <4CF3FB20.2040100@computer.org> <1291061079.5909.84.camel@bellatrix.morrisoft.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1291061079.5909.84.camel@bellatrix.morrisoft.local>
Sender: linux-raid-owner@vger.kernel.org
To: Michele Bonera <mbonera@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/11/10 21:04, Michele Bonera wrote:
> The problem is that I added a device partition (sdc1) but after the
> crash the array has sdc (the device) as one of his components. The
> partition table on the disk was wiped-out.
>
> The result is that the filesystem on it (dev/md6) is unreadable and
> fsck.ext3 can't fix it.

Right. This is consistent with what I've seen as well.

I can't help you repair this filesystem, but when you do my suggestion 
remains to change the partition types of the RAID members. This is 
because I've noticed that the in-kernel RAID detection and assembly code 
sometimes gets it wrong (leading to the kinds of symptoms you've 
reported), whereas mdadm run from the initrd does not.
