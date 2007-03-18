From: Neil Brown <neilb@suse.de>
Subject: Re: Data corruption on software raid.
Date: Mon, 19 Mar 2007 09:19:35 +1100
Message-ID: <17917.47863.252726.543202@notabene.brown>
References: <20070318131606.GJ6063@freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sander Smeenk on Sunday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday March 18, ssmeenk@freshdot.net wrote:
> Hello!  Long story. Get some coke.

And a painful story!.

See also http://bugzilla.kernel.org/show_bug.cgi?id=8180

It also involves a Silicon Image PCI/SATA controller, though a
different model.

But then I have an SI PCI SATA controller that has never missed a beat
(except when on the of the SATA cables wasn't quite plugged in
properly....) 

I'd say it is definitely a hardware problem, though identifying which
piece of hardware can be tricky.

NeilBrown
