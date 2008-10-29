From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Wed, 29 Oct 2008 20:19:41 +1100
Message-ID: <18696.10925.969583.445231@notabene.brown>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday October 28
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday October 28, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> This update allows imsm containers and member arrays to be discovered
> with '-Eb' and subsequently assembled with '-As'.

Thanks Dan.  There's definitely some useful stuff in here.
Some of it may be made a lot simpler by some revamping I hoping to get
done before the weekend...

> 
> For example here is a test for assembling a 4 drive container with (1)
> 4-disk raid5 array plus one spare.
> 
> # echo "DEVICES /dev/loop[0-4]" > tmp/mdadm.conf
> 
> # mdadm -Ebsc tmp/mdadm.conf >> tmp/mdadm.conf
> 
> # cat tmp/mdadm.conf
> DEVICES /dev/loop[0-4]
> ARRAY /dev/imsm metadata=imsm auto=md UUID=b98f5dbe-aa859e7b-0e369b89-a80986d4
> ARRAY /dev/md/r1 container=/dev/imsm member=0 auto=mdp UUID=3538e39c-b397c2e9-1aa031f9-2bc0eca4
>    spares=1

I don't like the use of "/dev/imsm" is here.  It obviously doesn't
scale to more that one imsm array, and while we all know that the
world doesn't need more than about 5 computers, I suspect someone out
there will find 1 IMSM array limiting :-)

My approach for the "/dev/imsm" in the first line is simple to discard
it.  I've changed mdadm to allow the device name to be missing from
mdadm.conf and to not generate in for imsm and ddf.  When "mdadm -As"
tries to assemble such a device it makes up a name, which may not be
stable between reboots.  But if you are using mount-by-label then this
shouldn't be a problem.  And that seems to be the way the world is
going.

The "container=/dev/imsm" is slightly harder to deal with.  Just
leaving that out means there is no direct linkage between the two
lines.  That might be a problem, except for the next point, which
somewhat makes it moot.

One change I'm introducing in 3.0 is that 'homehost' will never be
NULL.  It now defaults to <system> which expands via 'gethostname()'.
One consequence of this is that
  mdadm -As
will, after it has processed all it can find in mdadm.conf will
attempt auto-assembly of anything else it can find.  Things that
aren't identified as belonging to 'this host' will still be assembled,
but with a guaranteed unique name.
This means that
   mdadm -As
with an empty mdadm.conf will now assemble everything it can find.
Hopefully I'll get around to coding it so they are assembled
'read-auto'.

If you do
  mdadm -Es > /tmp/mdadm.conf
  mdadm -Asc/tmp/mdadm.conf

you will get one slight difference.  Every array will be assumed to
belong to 'this' host (because they are listed in our local
mdadm.conf)  and mdadm will be a little more generous in giving
meaningful names.
Also, the members of a container are local if the container is local,
so you don't really need to list the members in the output of "-Es".

I'll try to make sure it still works if the members are listed without
a "container=" setting.  I toyed with the idea of supporting
"container=previous" or similar.  It's a bit ugly though.

In short, I plan to take all you patches.  Remove the references to
"/dev/imsm" and then make it all "do the right thing".

BTW, I'm currently prohibiting names like "/dev/imsm".  You would need
to use "/dev/md/imsm".  How much would that bother you?
I'm not completely committed to this, but it is a lot easier to impose
a more uniform naming scheme.

> 
> I suppose brief_examine_super_imsm() can be updated to look at the
> currently running kernel and not specify auto=mdp if the "extended
> partition" capability is available.  Is there a quick way to check for
> this capability?  You can see that I tagged this support as
> "preliminary" as it does not attempt to address the multiple container
> case, I left it alone for now as that solution depends on the device
> name rework.

I'm tempted to allow the metadata to provide hints as to whether
partitions are needed.  So you wouldn't need "auto=mdp" in mdadm.conf
- super-intel.c would somehow say "use partitions" (and 'ddf' would
say "don't") and mdadm would do as it is told.
The only way to check for the extended-minor-space is to check the
kernel version.  I prefer to avoid doing that where possible as it
breaks when distros backport things, but I think in this case it is
justified (and if a distro did back-port the extended minor space
without updating mdadm it would all still work, just slightly
differently).

> 
> Please have a look.

I have. Thanks.

I will try to have something credible on top of it pushed out by
tomorrow evening (24 hours from now).  I might even call it
mdadm-3.0-devel2 (which I've been promising for a couple of weeks
without delivering).

Thanks,
NeilBrown
