From: <robin-lists@robinbowes.com>
Subject: RE: what is the best multi-SATA-controller-on-a-single-board out there?
Date: Mon, 2 Aug 2004 23:48:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S264389AbUHBWsr/20040802224847Z+6586@vger.kernel.org>
References: <Pine.LNX.4.58.0408021700230.7852@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0408021700230.7852@web1.mmaero.com>
To: 'Jon Lewis' <jlewis@lewis.org>, 'Tim Small' <tim@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jon Lewis
> Sent: 02 August 2004 21:10
> To: Tim Small
> Cc: linux-raid@vger.kernel.org
> Subject: Re: what is the best 
> multi-SATA-controller-on-a-single-board out there?
> 
> On Mon, 2 Aug 2004, Tim Small wrote:
> 
> > The Promise cards, are cheap, but only do 66Mhz/32 bit PCI 
> and provide 
> > four SATA ports, so they may not be well suited to some 
> boards..  Both 
> > chipsets were used with libata on 2.6 kernels, with a 
> mixture of s/w 
> > raid5, and s/w raid1.  The only slight irritation is the 
> current lack 
> > of smartd support (pending libata driver support).
> 
> With what distros / exactly which kernels?  I've been testing 
> a system with 2 Promise SATA150 TX4's and 6 Maxtor 200gb SATA 
> drives in a supermicro (mb/chassis) system with 7 drive 
> hot-swap drive carrier.  I've been having serious problems 
> and am having trouble telling if its hardware or software.  
> I've been trying both Whitebox (basically RH ES 3.0 which 
> uses a 2.4 kernel and includes libata but doesn't build it by 
> default) and Fedora Core 2, which supports the SATA hardware 
> by default.  OS gets installed on smaller drives on the MB's 
> PATA controller.  The big 6 drives are supposed to be SW 
> RAID5.  The system usually locks up while building the array. 
>  Today it got as far as nearly finishing the mke2fs on the 
> array when it locked up.
> 
> Running badblocks on each 200gb drive individually, I got 
> errors on one of them once.  When I reran badblocks on that 
> drive, I did not get errors.
> I still can't get an array built/formatted (under whitebox 
> today) without the system locking up.
> 
> So, I'm curious who else is using the SATA150 TX4 and with 
> which kernel/driver and whether they're having or have seen 
> any similar problems.

Jon,

I've got a very similar setup to you - 2 x SATA150 TX4 with 6 x Maxtor 250GB
drives.

I had exactly the same symptoms and I found it was caused by failing drives.
I think I got a bad batch, or a bad supplier or something because I had
three out of a batch of four fail. I got replacements from Maxtor (3 year
warranty) and have not had any problems since.

When you RMA their drives they ask that you download a utility called
"powermax" and check out the drives before returning them - the utility
gives you a failure code if the drive is bad. Try downloading it and running
the quick test on your drives. I'll give you 5-1 that they will fail.

R.
--
http://robinbowes.com 

