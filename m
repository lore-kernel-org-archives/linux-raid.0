From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: LVM performance
Date: Wed, 20 Feb 2008 00:19:27 +0100
Message-ID: <47BB63FF.3040202@rabbit.us>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com> <20080218154203.6e2d1483@szpak> <47BB30DF.1080006@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47BB30DF.1080006@student.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oliver Martin wrote:
> Interesting. I'm seeing a 20% performance drop too, with default RAID 
> and LVM chunk sizes of 64K and 4M, respectively. Since 64K divides 4M 
> evenly, I'd think there shouldn't be such a big performance penalty.

I am no expert, but as far as I have read you must not only have compatible 
chunk sizes (which is easy and most often the case). You also must stripe 
align the LVM chunks, so every chunk spans an even number of raid stripes (not 
raid chunks). Check the output of `dmsetup table`. The last number is the 
offset of the underlying block device at which the LVM data portion starts. It 
must be divisible by the raid stripe length (the length varies for different 
raid types).

Currently LVM does not offer an easy way to do such alignment, you have to do 
it manually upon executing pvcreate. By using the option --metadatasize one 
can specify the size of the area between the LVM header (64KiB) and the start 
of the data area. So one would supply STRIPE_SIZE - 64 for metadatasize[*], 
and the result will be a stripe aligned LVM.

This information is unverified, I just compiled it from different list threads 
and whatnot. I did this to my own arrays/volumes and I get near 100% raw 
speed. If someone else can confirm the validity of this - it would be great.

Peter

* The supplied number is always rounded up to be divisible by 64KiB, so the 
smallest total LVM header is at least 128KiB
