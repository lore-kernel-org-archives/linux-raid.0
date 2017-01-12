From: Phil Turmel <philip@turmel.org>
Subject: Re: Recommendation on new system Arrays
Date: Thu, 12 Jan 2017 10:39:52 -0500
Message-ID: <030ca00a-f024-14a0-d5b9-a9497811910e@turmel.org>
References: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
 <5870BD30.3020302@youngman.org.uk>
 <6017e35e-6328-bf8b-fb25-eb8afbf163ba@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6017e35e-6328-bf8b-fb25-eb8afbf163ba@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ben,

{Convention on kernel.org is reply-to-all -- please do.}

On 01/07/2017 11:04 PM, Benjammin2068 wrote:

> Also in other news.... (maybe someone from this list can help since they've run into it before)
> 
> The motherboard of the computer has its own SATA controller as usual... as well as this Avago SAS controller.
> 
> When CentOS 7 boots up, it enumerates the external SAS drives starting at /dev/sda instead of the motherboard's drives.
> 
> The OCD in me wants the MB's SATA drives as /dev/sda-sdd.
> 
> Where does one even control that enumeration order? udev? Eeks.

You cannot control the order.  Period.  It is pseudo-random based on
hardware responses to driver loads.  New kernels can have entirely
different orders of devices, and if parallel loads are allowed, you can
have one controller get sd[aceg] while another gets sd[bdfh]. The entire
system of LABEL= and UUID= support via initramfs and blkid is intended
make fstab and other utilities deterministic in spite of varying names.

mdadm has always been resistant to naming problems thanks to its device
#s and UUIDs in the superblocks.

Phil
