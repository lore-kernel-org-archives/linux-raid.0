From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Thu, 30 Oct 2008 23:43:34 +1100
Message-ID: <18697.44022.606760.169078@notabene.brown>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
	<18696.10925.969583.445231@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Wednesday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday October 29, neilb@suse.de wrote:
> 
> I will try to have something credible on top of it pushed out by
> tomorrow evening (24 hours from now).  I might even call it
> mdadm-3.0-devel2 (which I've been promising for a couple of weeks
> without delivering).


Well, I didn't quite make that, things always take longer than you
expect.
But I have pushed out a 'scratch-3.0' which is my current working
code.  Some of it will probably be revised which is why it isn't in
devel-3.0 yet.  But it is there to be looked at (or laughed at?) and
maybe tested a bit.

You might like to run with

 export MDADM_NO_UDEV=1

so that it doesn't depend on udev to create all the links, as some of
that doesn't quite work right yet.

NeilBrown
