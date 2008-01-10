From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Wed, 09 Jan 2008 21:56:38 -0700
Message-ID: <1199940998.13169.5.camel@dwillia2-linux.ch.intel.com>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
	 <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
	 <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
	 <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
	 <alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org>
	 <e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com>
	 <alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org>
	 <1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>
	 <18309.25170.258730.225322@notabene.brown>
	 <e9c3a7c20801091907k732b0fcfw8b74502cca76f972@mail.gmail.com>
	 <18309.38832.518580.235804@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18309.38832.518580.235804@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2008-01-09 at 20:57 -0700, Neil Brown wrote:
> So I'm incline to leave it as "do as much work as is available to be
> done" as that is simplest.  But I can probably be talked out of it
> with a convincing argument....

Well, in an age of CFS and CFQ it smacks of 'unfairness'.  But does that
trump KISS...? Probably not.

--
Dan

