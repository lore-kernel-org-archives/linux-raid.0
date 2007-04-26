From: Neil Brown <neilb@suse.de>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing assembly.
Date: Thu, 26 Apr 2007 16:47:41 +1000
Message-ID: <17968.19213.125326.288897@notabene.brown>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>
	<462CF303.6030004@dgreaves.com>
	<c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>
	<c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>
	<462DC0B0.9010105@dgreaves.com>
	<c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Leon Woestenberg on Tuesday April 24
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 24, leon.woestenberg@gmail.com wrote:
> David,
> 
> thanks for all the advice so far.
> 
> On 4/24/07, David Greaves <david@dgreaves.com> wrote:
> >
> > Essentially all --create does is create superblocks with the data you want (eg
> > slot numbers). It does not touch other 'on disk data'.
> > It is safe to run the *exact same* create command on a dormant array at any time
> > after initial creation - the main side effect is a new UUID.
> > (Neil - yell if I'm wrong).

Close enough.  The "active/clean" flag also gets changed.
And for raid5, you want "--force" or it will make a degraded array
with one spare which may not be what you want.


> >
> In first instance we were searching for ways to tell mdadm what we
> know about the array (through mdadm.conf) but from all advice we got

"mdadm.conf" doesn't really know anything about the shape of the
array.  It just describes how to discover and recognise component
devices.   The metadata on the device is authoritative, and if it is
corrupt.... it is corrupt.

> we have to take the 'usual' non-syncing-recreate approach.

If "mdadm -f" doesn't work, then there is rarely any other option but
re-creating the array.  If you a reasonably careful the data will
still be there (unless it was corrupted by whatever corrupted the
metadata). 

NeilBrown
