From: Jeff Garzik <jeff@garzik.org>
Subject: Re: removing AHCI SATA devices
Date: Tue, 22 Feb 2011 16:36:20 -0500
Message-ID: <4D642C54.9040604@garzik.org>
References: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/22/2011 11:05 AM, Simon Mcnair wrote:
> hi all,
> Whilst I am aware that with AHCI and SATAII I can just unplug a HDD at
> will what is the correct process for doing a 'clean' dismount ?
>
> Since MD is a layer over the top of the physical device how can you
> ensure with certainty that all data has been flushed and the device
> removal is clean ?

Simply unplugged the hard drive's SATA cable should be fine.

	Jeff



