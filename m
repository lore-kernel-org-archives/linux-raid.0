From: Daniel McNeil <daniel@osdl.org>
Subject: Re: [PATCH 2.5.68] eliminate deprecated
	MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT in md.c
Date: 12 May 2003 11:23:07 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052763787.2491.142.camel@ibm-c.pdx.osdl.net>
References: <3EA595D9.E4CBB684@SteelEye.com>
	 <16037.55226.267006.507998@notabene.cse.unsw.edu.au>
	 <3EA6BA35.3A5F25CF@SteelEye.com>
	 <16049.64476.440042.635337@notabene.cse.unsw.edu.au>
	 <3EB2EA71.BA0DC039@SteelEye.com>
	 <1052515181.2492.67.camel@ibm-c.pdx.osdl.net>
	 <3EBC7D09.CF92454F@SteelEye.com>  <3EBF49A4.2BAFB3A4@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EBF49A4.2BAFB3A4@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Paul,

This looks good.  I really don't like having the module adding a
reference to itself, but in this case we know that it is not the
first reference.  __module_get() checks this with a BUG_ON.

Having md_exit() removed the attached but not active drives would
be safe:
If someone is in the middle of an ioctl then the module reference 
would not zero and the module couldn't be unloaded.
If someone tries to open an md device after the unload starts,
the opens will fail because try_module_get() fails while a module
is being unloaded.
If the md_exit() cleans up all the attached drives -- no memory
leaks or kernel panics.

This would get rid of the internal __module_get(THIS_MODULE) calls
and makes the code cleaner for module referencing, but
how would an administrator expect this to function? 
Is it normal to have half-assembled arrays or arrays not running
with drives attached?

Anyway, your patch looks good.

Daniel

On Fri, 2003-05-09 at 21:16, Paul Clements wrote:
> Wouldn't another choice be for md_exit() to loop through and drop
> > all drives that are attached?
> 
> Yes, that is another option, but presumably you don't want md to get
> unloaded if you're in the middle of configuring an array...
> 
> Admittedly, some of these scenarios are a little bit far fetched...but
> since they can result in a kernel panic or memory leaks, I guess it's
> better to be safe than sorry.
> 
> --
> Paul

On Mon, 2003-05-12 at 00:13, Paul Clements wrote:
> Daniel McNeil wrote:
> > The try_module_get() should be a __module_get() since we better already
> > have a module reference -- doing a try_module_get(THIS_MODULE)
> > better not add the 1st reference.
> 
> 
> OK, after looking a little more closely at module.c, I think I see what
> you're saying:
> 
> try_module_get(THIS_MODULE) is overkill (either that or we're running
> inside of md without a module reference to md, which is dangerous). So
> __module_get(THIS_MODULE) is enough. 
> 
> Here's the updated patch, against 2.5.69, compiled and tested to verify
> that module ref counting is correct (esp. in the case of an inactive
> array with bound device(s)).
> 
> Daniel, thanks for your input on this...
> 
> Neil, I believe this patch finally closes all the holes...
> 
> --
> Paul


