From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: raid10 vs raid5 - strange performance
Date: Thu, 27 Mar 2008 02:11:43 +0100
Message-ID: <bb145bd20803261811t6d836064g67d971a075075018@mail.gmail.com>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
	 <20080325233649.GA632@rap.rap.dk>
	 <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com>
	 <20080326072416.GA8674@rap.rap.dk>
	 <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>
	 <20080326192935.GB18621@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080326192935.GB18621@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@dkuug.dk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>  I have two on-board sata controller chips with each their version of HW
>  RAID (NVIDIA and SIL)

I don't know of any nVIdia or Silicon Image onboard chips that can do
raid in HW. Most likely it's BIOS-assisted software RAID. The 3ware
should be the real article.

>  I think there is a tendency that SW raid like Linux kernel MD and Sun ZFS
>  etc are more intelligent and can thus obtain better performance than HW
>  RAID.

Performance is one thing, flexibility is another ...
- end-to-end checksumming
- ECC-on-read and / or bg scrubbing
- arbitrary percentage of parity data (fs-level PAR2)
- virtualized storage pools with actual backing store chosen based on
usage hints
- all configurable rule-based with file level granularity

Sort of like a stable ZFS+raif variant ... one can only dream :-)

>  HW RAID has the advantage as Bill says that you only need to
>  transfer the data once when writing, and that parity calculation is
>  offloaded from the main CPUs.

Yes, maybe current cards conserve bus bandwidth even for RAID 10. Mine
doesn't, and there's no parity to offload. I don't like HW controllers
much since the on-disk format is closed ... if the controller dies you
have to get a very similar one, which can be a pain.

>  If you reuse older hw, then I would say that you really have a problem
>  with the PCI bus here, and that a motherboard with better bus
>  performance

The board has 5 bus segments, only most are PCIe. Boards with decent
PCI slots are getting hard to find ...

Nah, I'll just live with it until the disks start croaking ^^

Thanks,

C.
