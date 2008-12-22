From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Spread Spectrum (SSC) Enable or Disable?
Date: Mon, 22 Dec 2008 23:59:22 +0200
Message-ID: <20081222215922.GI30968@mea-ext.zmailer.org>
References: <alpine.DEB.1.10.0812220857410.27615@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812220857410.27615@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

On Mon, Dec 22, 2008 at 08:58:37AM -0500, Justin Piszcz wrote:
> 
> Besides the power supply/surge/etc with a lot of drives-- I have read:
>
> http://www.wrightthisway.com/Articles/cat_reviews.html
> "As I mentioned earlier, the enclosure will definitely handle drives using
> Spread Spectrum Clocking (SSC), an increasingly common feature that helps
> reduce electromagnetic interference, especially between drives in close
> proximity with each others, such as you might have in a RAID setup, so
> that is a definite plus here."

The SSC is implemented by intentionally adding JITTER on a clock signal.
Problems surface when such jittery clock is reading/writing disk surface..

SSC does "help" on EMC compliance by spreading the leaked clock signal
to wider frequency range -- effectively lowering the power at any given
single frequency, but at same time increasing total leaked power...

SSC works fine with some things, with others it will need asynchronous
elastic buffering (known as FIFO) when communicating with precission
synchronous clocking domain.  Harddrives, USB, SATA, etc. serial links
I would not dare to run with SSC clocks -- and properly done circuitboard
does not radiate electrical noise.

> With 16-24 disks-- if they are close together, it sounds like a good idea
> to use Spread Spectrum Clocking?
> Does anyone here with a large-ish raid array use this?

I would consider that BAD IDEA -- intentionally lowering system reliability
by adding jitter on clocks is ...  wrong way to fix the EMC issues.

Hiding the leaked oscillator signal with SSC out of a device does not have
any effect on reducing device susceptibility on externally originating RFI.
I never use SSC, but then my designs can afford that 5 dollars more expensive
circuit-board..

> Any enterprise-insiders care to comment?
> Justin.

Matti
