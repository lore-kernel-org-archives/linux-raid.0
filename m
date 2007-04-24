From: David Greaves <david@dgreaves.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing
 assembly.
Date: Tue, 24 Apr 2007 14:06:53 +0100
Message-ID: <462E00ED.3050006@dgreaves.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>	 <462CF303.6030004@dgreaves.com>	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>	 <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>	 <462DC0B0.9010105@dgreaves.com> <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leon Woestenberg wrote:
> David,
> 
> thanks for all the advice so far.

No problem :)

> In first instance we were searching for ways to tell mdadm what we
> know about the array (through mdadm.conf) but from all advice we got
> we have to take the 'usual' non-syncing-recreate approach.
> 
> We will try to make disk clones first. Will dd suffice or do I need
> something more fancy that maybe copes with source drive read errors in
> a better fashion?

ddrescue and dd_rescue are *much* better.

I favour the gnu ddrescue - it's much easier. But sometimes, on some kernels
with some hardware I've had kernel locks that dd_rescue (eventually, after many
minutes) times out from.

The RIP iso is a good place to start.
http://www.tux.org/pub/people/kent-robotti/looplinux/rip/

David
