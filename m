From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2.6.20-rc6] md: expose uuid and degraded attributes in
 sysfs
Date: Sun, 11 Feb 2007 08:15:31 +1100
Message-ID: <17870.13811.570367.617924@notabene.brown>
References: <20070127015948.GA24479@teal.hq.k1024.org>
	<20070210111836.GA7953@teal.hq.k1024.org>
	<45CE0A5D.6040409@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Saturday February 10
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, iusty@k1024.org
List-Id: linux-raid.ids

On Saturday February 10, davidsen@tmr.com wrote:
> Iustin Pop wrote:
> > On Sat, Jan 27, 2007 at 02:59:48AM +0100, Iustin Pop wrote:
> >   
> >> From: Iustin Pop <iusty@k1024.org>
> >>
> >> This patch exposes the uuid and the degraded status of an assembled
> >> array through sysfs.
> >>     
> > [...]
> >
> > Sorry to ask, this was my first patch and I'm not sure what is the
> > procedure to get it considered for merging... I was under the impression
> > that just sending it to this list is enough. What do I have to do?
> Normally I would expect Neil to pick it up and forward it, but I would 
> have expected an ack from him. He's been busy with other problems, NFS 
> as I recall, and may have missed it, so I cc'd him this time.
> 
> Neil, I would think this is 2.6.21 material unless you see a problem I 
> missed.
> 

yeh - sorry about that. mail is somewhat of a lossy protocol for me.
I usually try to reply, but sometimes it just doesn't happen.
Resending after a suitable pause (1-2 weeks) is never a bad idea.

Exposing the 'degraded' status is probably a good idea.  I'll take
that.

Exposing the UUID isn't - and if it were it should be in
"md_default_attrs" rather than "md_redundancy_attrs".

The UUID isn't an intrinsic aspect of the array.  It is simply part of
the metadata that is used to match up different devices from the same
array.
I plan to add support for the 'DDF' metadata format (an 'industry
standard') and that will be managed entirely in user-space.  The
kernel won't know the uuid at all.

So any solution for easy access to uuids should be done in user-space.
Maybe mdadm could create a link
   /dev/md/by-uuid/xxxxxxxx -> /dev/whatever.
??

NeilBrown
