From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 17:53:04 +0200
Message-ID: <ir62p0$b5o$1@dough.gmane.org>
References: <9067914580344941270@unknownmsgid>	<ir58vs$9qp$1@dough.gmane.org> <20110520145623.749b4781@natsu> <ir5ci1$uc6$1@dough.gmane.org> <4DD65A66.5030904@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD65A66.5030904@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op 20-05-11 14:11, Phil Turmel schreef:
> On 05/20/2011 05:33 AM, Paul van der Vlis wrote:
>> 
>> The problem is about detected disks with a defect in the MBR.
> 
> This is a crucial point.  A BIOS that supports multiple drives in the
> boot order should skip to the next if the MBR cannot be read.  But
> the BIOS loses control once the MBR code is executed.  If an error is
> encountered in later sectors of the bootloader, there's no way to
> switch to the next drive.  This is also true when the BIOS only
> supports dissimilar devices in the boot order.

I think you are right.

> If I had to minimize the chance of this ever biting me, I'd use a CF
> <==> IDE adapter with a DMA capable CF card, and set it up as my boot
> device.  And I wouldn't use it for anything but boot.  A quick google
> turned up this:
> 
> http://www.addonics.com/products/flash_memory_reader/adidecf.asp

In the servers I use, there is normally no place for such a cardreader.
But a low profile PCI card with a CF card on it could do it.

> (Just to show what's out there.)  The embedded boards I use
> occasionally have the equivalent of this soldered to their
> motherboards.
> 
> The best DMA capable CF cards are usually found in markets that cater
> to industrial designers or to professional photographers.

Do you think the risk of a problem with a CF card (or something like
that) is much lower then the risk of a problem with a harddisk?

And what about booting from an USB stick?

With regards,
Paul van der Vlis.


-- 
http://www.vandervlis.nl



