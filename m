From: Tim Southerwood <ts@dionic.net>
Subject: Re: Any inexpensive hardware recommendations for PCI interface cards?
Date: Fri, 08 Feb 2008 11:47:36 +0000
Message-ID: <47AC4158.4050106@dionic.net>
References: <11ae01c86a44$aff357a0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11ae01c86a44$aff357a0$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Steve,

Steve Fairbairn wrote:

<snip>

> Is anyone using an array with disks on PCI interface cards?

Almost, I have a Sil3132 PCI-E card (2 port SATA-300) mixed with 6 on
board ports (on Asus M2N-E mobo). No problems there, I quite pleased
with it.

> Is there an issue with mixing motherboard interfaces and PCI card based
> ones?

Not fundamentally. Speed issues may depend on whether the PCI bus to the
sockets is shared with the on board SATA chip, or if they are off
different busses.

> Does anyone recommend any inexpensive (probably SATA-II) PCI interface
> cards?

Unfortunately, the SiL3132 doesn't have an obvious PCI sibling.

You might consider a SiL3124 based card:

http://www.siliconimage.com/products/product.aspx?id=27

example card here:

http://www.satacard.com/

Price isn't so cheap though. If you can drop to SATA-150 (SATA I) then
you get the SiL3114 chips which are much more common (=cheap).

I can't vouch personally for those other chips, but I remember seeing
favourable reviews when I was searching for for SATA controllers.


Sorry I can't be of more help - just chucking some ideas back...

Cheers

Tim
