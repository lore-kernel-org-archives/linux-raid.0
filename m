From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linux MD? Or an H710p?
Date: Sun, 20 Oct 2013 02:37:44 -0500
Message-ID: <52638848.1080400@hardwarefreak.com>
References: <526328AE.2020908@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526328AE.2020908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/19/2013 7:49 PM, Steve Bergman wrote:
> Hello,
> 
> I'm configuring a PowerEdge R520 that I'll be installing RHEL 6.4 on
> next month. (Actually, Scientific Linux 6.4) I'll be upgrading to RHEL
> (SL) 7 when it's available, which is looking like it might default to XFS.
> 
> This will be a 6 drive RAID10 set up for ~100 Gnome (freenx) desktop
> users and a virtual Windows 2008 Server guest running MS-SQL, so there
> is plenty of opportunity for i/o parallelism. This seems a good fit for
> XFS.
> 
> My preference would be to use Linux MD RAID10. But the Dell configurator
> seems strongly inclined to force me towards hardware RAID.
> 
> My choices would be to get a PERC H310 controller that I don't need,
> plus a SAS controller that the drives would actually connect to, and use
> Linux md. Or I can go with a PERC H710p w/1GB NV cache running hardware
> RAID10. (Dell says their RAID cards have to function as RAID
> controllers, and cannot act as simple SAS controllers.)
> 
> I also have a choice between 600GB 15k drives and 600GB 10k "HYB CARR"
> drives, which I take to be 2.5" hybrid SSD/Rotational drives in a 3.5"
> mounting adapter.
> 
> Any comments on any of this? This is a bit fancier than what I usually
> configure. And I'm not sure what the performance and operational
> differences would be. I know that I'm familiar with Linux's software
> RAID tools. And I know I like the way I can replace a drive and have it
> sync up transparently in the background while the server is operational.
> I don't yet know if I can do that with the H710p card. I also like how I
> just *know* that XFS if configuring stride, etc. properly with MD. With
> the H710p, I don't know what, if anything, the card is telling the OS
> about the underlying RAID configuration. I also just plain like MD.
> 
> I like the 1GB NV cache I get if I go hardware RAID, which I don't get
> with the simple SAS controller. (I could turn off barriers.) I also like
> the fact that it seems a more standard Dell configuration. (They won't
> even connect the drives to the SAS controller at the factory.)
> 
> Any general guidance would be appreciated. We'll probably be keeping
> this server for 7 years, and it's pretty important to us. So I'm really
> wanting to get this right.

Do what everyone else does in this situation:  Buy the box with
everything you want minus the disk controller.  Purchase an LSI 9211-8i
and cables, pop the lid and install it, takes 5 minutes tops.  Runs $300
for the KIT, about $250 if you buy the OEM card and 2x .5M cables
separately.

http://www.lsi.com/products/host-bus-adapters/pages/lsi-sas-9211-8i.aspx

-- 
Stan

