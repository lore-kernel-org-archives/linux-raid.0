From: Neil Brown <neilb@suse.de>
Subject: Re: Confused About Results of Constructing raid10 Array
Date: Mon, 13 Oct 2008 11:25:16 +1100
Message-ID: <18674.38252.660086.361249@notabene.brown>
References: <200810111527.12594.treborrude@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Trebor A. Rude on Saturday October 11
Sender: linux-raid-owner@vger.kernel.org
To: "Trebor A. Rude" <treborrude@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 11, treborrude@comcast.net wrote:
> And here's the detail:
> 
> hyperion ~ # mdadm --detail /dev/md3
> /dev/md3:
>         Version : 00.90
>   Creation Time : Wed Oct  8 23:41:22 2008
>      Raid Level : raid10
>      Array Size : 878907840 (838.19 GiB 900.00 GB)
>   Used Dev Size : 585938560 (558.79 GiB 600.00 GB)
...
> 
> There are two things I don't understand here:
> 
> Why does the "Layout" line say "near=1, far=2"? Does that indicate that there 
> are three copies of every block? Even though I have three drives, I only 
> wanted two copies of each block.

No.  The total number of copies is (near * far).  2 in this case.
I can that might be confusing.

> 
> Where's the rest of my space? I put 1800 GB (again, base 10) of space into the 
> array, but the total of "Array Size" and "Used Dev Size" is only 1500 GB. 
> Where's the other 300 GB? Was it lost to formatting?

Why are you adding these numbers???

There is 600GB total on each of 3 devices.  That is a total of 1800GB.
You have two copies of each block of data, so there is room for 900GB
of data.
The "600GB" is the number shown in "Used Dev Size" - it is the space in
each device that is actually used.
The "900GB" is the "Array Size".  It is the amount of available space
in the array.

It looks like it is doing exactly what you want.

NeilBrown
