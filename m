From: Thomas Horsten <thomas@horsten.com>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 22:38:40 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310132238.40012.thomas@horsten.com>
References: <200310131921.45824.thomas@horsten.com> <200310132025.30939.thomas@horsten.com> <20031013211722.GG23916@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031013211722.GG23916@marowsky-bree.de>
Content-Disposition: inline
To: Lars Marowsky-Bree <lmb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 13 October 2003 22:17, Lars Marowsky-Bree wrote:

> "BIOS RAIDs" is a rather sweet euphemism for "crippled pretense of
> hardware RAID, which is in fact emulated by software". I've got no
> problem with telling the users that what they have _is_ software RAID
> and needs to be treated as such.

I completely agree with you, and I will make sure my drivers print "Software 
RAID" all over the screen when it loads :-) Ok, at least on one line then. 
I'm not on a mission to justify the marketing methods of chip manufactureres.

Having said that, BIOS RAID does solve a few problems inherent to software 
RAID's, particularly the boot process and consistency of RAID's between 
operating systems. I want to leverage those advantages and I think that this 
is best done with an autodetecting driver.

> Windows doesn't use the BIOS to access the device at all; the
> corresponding hardware drivers emulate that.

I know, but the BIOS supports its boot up to 32-bit mode. Which means you 
could see the drive from DOS, etc. And putting the RAID in BIOS does have 
some advantages for the average PC motherboard.

Best regards,

Thomas

