From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Sat, 5 Jul 2008 19:24:52 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48700228.7060904@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Sat, 5 Jul 2008, Robert Hancock wrote:

> Justin Piszcz wrote:
>>> Can you post your dmesg from bootup with the controller/drive detection?
>
> So you've got 6 drives in the machine. Intel chipsets normally seem pretty 
> robust with AHCI.
>
> Are you certain that your machine has enough power to run all those drives 
> properly? We've seen in a number of cases that power fluctuations or noise 
> can cause these kinds of errors.

I have a 650watt PSU (nice antec one) and the power draw of the box is 
~148watts w/ veliciraptors, ~250 when fully load all 4 cores + all 12 
disks writing.  I have turned off the irqbalance daemon and I am going to 
see if the problem re-occurs.

Justin.
