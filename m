From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: 8-port SATA PCI/PCIX adaptor
Date: Sat, 2 Apr 2005 09:52:21 -0600
Message-ID: <20050402155221.GA22746@lists.us.dell.com>
References: <d2mae1$ii$1@sea.gmane.org> <Pine.LNX.4.56.0504021552250.30253@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0504021552250.30253@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 02, 2005 at 04:04:48PM +0100, Gordon Henderson wrote:
> The cheaper cards that I've used seem to have mostly the SII chipset - and
> that appears to be well supported by Linux. The 3112 is a dual-port card,
> the 3114, quad. There are RAID and non-RAID variants, and all the ones
> I've used seem to have a JBOD mode anyway (so you use s/w RAID rather than
> their supplied h/w RAID) (The exception would seem to be the Dell/Adaptec
> 6-port SATA card I had recently - it has 3 x SII 3112 chips on it, and a
> big Adaptec/Dell chip which hides them from bus )-:

The Dell CERC SATA 1.5/6ch cards use the standard aacraid driver, so
no worries about unavailable/closed-source drivers there.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
