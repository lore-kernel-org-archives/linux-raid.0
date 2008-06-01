From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm raid10 performance
Date: Sun, 1 Jun 2008 17:22:04 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806011719530.11366@p34.internal.lan>
References: <b8f627e0806011347x49630976gf9bcf57d7356489b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b8f627e0806011347x49630976gf9bcf57d7356489b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?KOI8-R?B?7cHSyyDrz9LFzsLF0sc=?= <socketpair@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 2 Jun 2008, ???? ????????? wrote:

> Hello. I have a simple question.
>
> I just created mdadm raid10 with four disks. The raid  build process
> complete successfully.
> All of 4 HDD are connected with separate SATA wires directly to motherboard.

> The mode of operation (selected in bios) neither AHCI nor RAID.
>
> I decide to acheive performance information of software RAID.
> So I read 10 blocks by 64Mb. This give me roughly performance of one disk.
> (I expect that it will be 4x speed ! it should read from 4 hdd
> simultaneously!!!, BUT NOT! )
1. What motherboard?  Does it have PCI-e lanes?  Or is the I/O on the regular
PCI bus?  If you have 8 CPUs as it shows below you really should not be running
into I/O problems, see my earlier post to the mailing list, you want to run
something similar to:

dd if=/dev/sda of=/dev/null bs=1M
dd if=/dev/sdb of=/dev/null bs=1M

Then, run:
dstat -D sda,sdb,sdc,sdd

Show the output!

>
> So, second test were reading 10 blocks (from 0 to 9) in one process,
> and 10 blocks (from 10 to 19) in second thread.
> I acheive performance of half disk... in each thread.
2. I am not sure how RAID10 in linux handles it but with raid1 you need to use
2 or 3 threads simultaenously to pull data from multiple disks _and_ you need
a backplane/interface/chipset that can handle that bandwidth.

Justin.

