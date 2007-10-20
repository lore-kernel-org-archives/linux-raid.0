From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID when it works and when it doesn't
Date: Sat, 20 Oct 2007 09:55:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710200954370.410@p34.internal.lan>
References: <14526.1192571833@mdt.ecitele.com>  <87bqaw5tqb.fsf@informatik.uni-tuebingen.de>
 <1192777672.16416.495.camel@w100> <Pine.LNX.4.64.0710191102110.27246@p34.internal.lan>
 <471A065F.9030202@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471A065F.9030202@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alberto Alonso <alberto@ggsys.net>, Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 20 Oct 2007, Michael Tokarev wrote:

> There was an idea some years ago about having an additional layer on
> between a block device and whatever else is above it (filesystem or
> something else), that will just do bad block remapping.  Maybe it was
> even implemented in LVM or IBM-proposed EVMS (the version that included
> in-kernel stuff too, not only the userspace management), but I don't
> remember details anymore.  In any case, - but again, if memory serves
> me right, -- there was low interest in that because of exactly this --
> drives are now more intelligent, there's hardly a notion of "bad block"
> anymore, at least persistent bad block, -- at least visible to the
> upper layers.
>
> /mjt
>

When I run 3dm2 (3ware 3dm2/tools/daemon) I often see LBA remapped sector, 
success, etc..

My question is, how come I do not see this with mdadm/software raid?

Justin.
