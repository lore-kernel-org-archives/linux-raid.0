From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.27.8: OOM killer: [swapper: page allocation failure]
Date: Fri, 12 Dec 2008 12:12:27 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812121211580.5119@p34.internal.lan>
References: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Fri, 12 Dec 2008, Justin Piszcz wrote:

> Kernel: 2.6.27.8
>
> I have a RAID-6 volume with 6 disks:
> mdadm --create -v /dev/md0 --level=6 -n 6 -e 0.90 /dev/sd[e-j]1
>
> While it is building...

Removed the extra disks, put them in another host but thought it was an
interesting bug.? so sent it to the list.

Justin.

