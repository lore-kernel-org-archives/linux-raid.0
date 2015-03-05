From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 10 Issue
Date: Thu, 05 Mar 2015 15:07:46 -0500
Message-ID: <54F8B792.9060206@turmel.org>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/05/2015 12:56 PM, Stefan Lamby wrote:
> Hello List.
> 
> I was setting up a new machine using ubuntu 14.04.02 lts using its installer,
> configuring a raid 10 with 2 disks and lvm on top of it. I was using 2 disks and
> now I like to add 2 more disks to the array so i want to end up with 4 disks, no
> spare.
> 
> Searching the internet I found that I am not able to --grow the array with the
> mdadm version this ubuntu is using (v3.2.5).
> Is that right?
> 
> So I decided to build a new array that way and try to move my data afterwards,
> which failed:
> (Is it OK to do it that way or do you recommend another?)

No, you should be able to do this.  Probably without any shutdown.
Please show the full layout of your drives, partitions, and lvm.

I suggest lsdrv[1] for working layouts.  If your email is set to use
utf8, just paste the result in a reply.

Regards,

Phil Turmel

[1] https://github.com/pturmel/lsdrv
