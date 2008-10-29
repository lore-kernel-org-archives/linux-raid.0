From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Wed, 29 Oct 2008 09:12:17 -0700
Message-ID: <e9c3a7c20810290912k6530790dv5cf7f6db8ff40389@mail.gmail.com>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
	 <18696.10925.969583.445231@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18696.10925.969583.445231@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Oct 29, 2008 at 2:19 AM, Neil Brown <neilb@suse.de> wrote:
> The "container=/dev/imsm" is slightly harder to deal with.  Just
> leaving that out means there is no direct linkage between the two
> lines.  That might be a problem, except for the next point, which
> somewhat makes it moot.
>
> One change I'm introducing in 3.0 is that 'homehost' will never be
> NULL.  It now defaults to <system> which expands via 'gethostname()'.
> One consequence of this is that
>  mdadm -As
> will, after it has processed all it can find in mdadm.conf will
> attempt auto-assembly of anything else it can find.  Things that
> aren't identified as belonging to 'this host' will still be assembled,
> but with a guaranteed unique name.
> This means that
>   mdadm -As
> with an empty mdadm.conf will now assemble everything it can find.
> Hopefully I'll get around to coding it so they are assembled
> 'read-auto'.
>
> If you do
>  mdadm -Es > /tmp/mdadm.conf
>  mdadm -Asc/tmp/mdadm.conf
>
> you will get one slight difference.  Every array will be assumed to
> belong to 'this' host (because they are listed in our local
> mdadm.conf)  and mdadm will be a little more generous in giving
> meaningful names.
> Also, the members of a container are local if the container is local,
> so you don't really need to list the members in the output of "-Es".
>
> I'll try to make sure it still works if the members are listed without
> a "container=" setting.  I toyed with the idea of supporting
> "container=previous" or similar.  It's a bit ugly though.
>

What about container=<container uuid> as we can never really discern
with certainty the name of the container device at
->brief_examine_super() time?

> In short, I plan to take all you patches.  Remove the references to
> "/dev/imsm" and then make it all "do the right thing".
>
> BTW, I'm currently prohibiting names like "/dev/imsm".  You would need
> to use "/dev/md/imsm".  How much would that bother you?
> I'm not completely committed to this, but it is a lot easier to impose
> a more uniform naming scheme.
>

I've been using /dev/imsm out of habit, but I can see how that might
cause problems with the /dev namespace.  /dev/md/imsm makes more
sense.

> I will try to have something credible on top of it pushed out by
> tomorrow evening (24 hours from now).  I might even call it
> mdadm-3.0-devel2 (which I've been promising for a couple of weeks
> without delivering).
>

Sounds good, thanks,
Dan
