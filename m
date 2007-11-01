From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Thu, 01 Nov 2007 14:02:24 -0700
Message-ID: <472A3EE0.3090503@zytor.com>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org>	 <1192810534.1666.68.camel@firewall.xsintricity.com>	 <471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>	 <471A47CC.1070508@msgid.tls.msk.ru>  <18205.2688.952701.567195@stoffel.org> <1193186569.10336.30.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193186569.10336.30.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
>>
>> I would argue that ext[234] should be clearing those 512 bytes.  Why
>> aren't they cleared  
> 
> Actually, I didn't think msdos used the first 512 bytes for the same
> reason ext3 doesn't: space for a boot sector.
> 

The creators of MS-DOS put the superblock in the bootsector, so that the 
BIOS loads them both.  It made sense in some diseased Microsoft 
programmer's mind.

Either way, for RAID-1 booting, the boot sector really should be part of 
the protected area (and go through the MD stack.)  The bootloader should 
deal with the offset problem by storing partition/filesystem-relative 
pointers, not absolute ones.

	-hpa
