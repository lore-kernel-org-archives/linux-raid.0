From: Neil Brown <neilb@suse.de>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 30 Oct 2007 14:25:35 +1100
Message-ID: <18214.42031.418516.420310@notabene.brown>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
	<18200.56684.14194.630264@stoffel.org>
	<1192813877.1666.79.camel@firewall.xsintricity.com>
	<18200.63987.514073.184865@stoffel.org>
	<471E7DC6.7050206@tmr.com>
	<1193184555.10336.3.camel@firewall.xsintricity.com>
	<18207.56169.769976.512617@notabene.brown>
	<471FDEB1.8040401@garzik.org>
	<47204F45.4010205@dgreaves.com>
	<18209.34365.375059.602828@notabene.brown>
	<4721F742.1090301@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday October 26
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Greaves <david@dgreaves.com>, Jeff Garzik <jeff@garzik.org>, Doug Ledford <dledford@redhat.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 26, davidsen@tmr.com wrote:
> 
> Perhaps you could have called them 1.start, 1.end, and 1.4k in the 
> beginning? Isn't hindsight wonderful?
> 

Those names seem good to me.  I wonder if it is safe to generate them
in "-Eb" output....

Maybe the key confusion here is between "version" numbers and
"revision" numbers.
When you have multiple versions, there is no implicit assumption that
one is better than another. "Here is my version of what happened, now
let's hear yours".
When you have multiple revisions, you do assume ongoing improvement.

v1.0  v1.1 and v1.2 are different version of the v1 superblock, which
itself is a revision of the v0...

NeilBrown
