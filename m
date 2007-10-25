From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Wed, 24 Oct 2007 20:09:21 -0400
Message-ID: <471FDEB1.8040401@garzik.org>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<18200.56684.14194.630264@stoffel.org>	<1192813877.1666.79.camel@firewall.xsintricity.com>	<18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>	<1193184555.10336.3.camel@firewall.xsintricity.com> <18207.56169.769976.512617@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18207.56169.769976.512617@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Bill Davidsen <davidsen@tmr.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 23, dledford@redhat.com wrote:
> As for where the metadata "should" be placed, it is interesting to
> observe that the SNIA's "DDFv1.2" puts it at the end of the device.
> And as DDF is an industry standard sponsored by multiple companies it
> must be ......
> Sorry.  I had intended to say "correct", but when it came to it, my
> fingers refused to type that word in that context.
> 
> DDF is in a somewhat different situation though.  It assumes that the
> components are whole devices, and that the controller has exclusive
> access - there is no way another controller could interpret the
> devices differently before the DDF controller has a chance.

<grin> agreed.


> DDF is also interesting in that it uses 512 byte alignment for
> metadata.  The 'anchor' block is in the last sector of the device.
> This contrasts with current md metadata which is all 4K aligned.
> Given that the drive manufacturers seem to be telling us that "4096 is
> the new 512", I think 4K alignment was a good idea.
> It could be that DDF actually specifies the anchor to reside in the
> last "block" rather than the last "sector", and it could be that the
> spec allows for block size to be device specific - I'd have to hunt
> through the spec again to be sure.

Its a bit of a mess.

Yes, with 1K and 4K sector devices starting to appear, as long as the 
underlying partitioning gets the initial partition alignment correct, 
this /should/ continue functioning as normal.

If for whatever reason you wind up with an odd-aligned 1K sector device 
and your data winds up aligned to even numbered [hard] sectors, 
performance will definitely suffer.

Mostly this is out of MD's hands, and up to the sysadmin and 
partitioning tools to get hard-sector alignment right.


> For the record, I have no intention of deprecating any of the metadata
> formats, not even 0.90.

strongly agreed


> It is conceivable that I could change the default, though that would
> require a decision as to what the new default would be.  I think it
> would have to be 1.0 or it would cause too much confusion.

A newer default would be nice.

	Jeff


