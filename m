From: Neil Brown <neilb@suse.de>
Subject: Re: Minor mdadm fixes
Date: Wed, 24 Mar 2010 11:27:40 +1100
Message-ID: <20100324112740.6b67b287@notabene.brown>
References: <4BA2DDB2.2040508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA2DDB2.2040508@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Mar 2010 22:13:06 -0400
Doug Ledford <dledford@redhat.com> wrote:

> I have several minor fixes against the 3.1.2 mdadm.

Thanks!

> 
> First attachment: mdadm-3.1.1-endian.patch
> Problem: on ppc arches mdadm would fail to assemble arrays if you used
> mdadm -Db /dev/<array> to populate the ARRAY line in mdadm.conf.  This
> is because the code in Detail.c calls fname_from_uuid() which honors the
> swapuuid setting in the superblock switch struct.  This is great for ddf
> and imsm superblocks which call fname_from_uuid() all over the place and
> are therefore consistent.  However, super1.c does *not* call
> fname_from_uuid()...ever.  And super1.c does *not* perform the byte
> swapping as per swapuuid in the switch struct.  At least not on
> *display*, but it *does* honor swapuuid on actual analysis of the uuid
> in terms of figuring out matches.  So, if you attempt to change the
> value of swapuuid in the super1 switch struct, then uuid's never match
> what's printed out (aka, the output of -D and -E both fail to match
> against the detected uuid when assembling, although at least -D and -E
> are now consistent).  Instead, I did a simple (and gross) hack to ignore
> swapuuid in fname_from_uuid() only for version 1 superblocks.  The other
> alternative might be to make super1.c call fname_from_uuid() all over
> the place instead of printing things out itself, but that would involve
> struct changes as the way it stores/accesses uuids in super1 is not per
> char like fname_from_uuid and that's precisely part of the problem.

Ohh, that is horrible isn't it.
I have applied your patch but I very much hope to "fix" the problem in a more
comprehensive way so that your fix will disappear.
I suspect that I will change the common code to use an array of bytes and do
any conversion from u32[4] to u8[1] in the per-metadata code.

> 
> Second: mdadm-3.1.2-mapfile.patch
> Problem: Neil's support for putting the mdadm map file wherever you need
> it is nice, but one place in particular needs a special case.
> Specifically, mdadm already creates /dev/md if needed to store symlinks,
> or in the case of mdmon needing to create pid/sock files (if ALT_RUN is
> set to /dev/md).  This creates an expectation in udev and friends that
> mdadm will create /dev/md when needed, period.  We need it if we place
> the mapfile in /dev/md prior to any symlinks or mdmon files being
> created, so special case that one location in order to make us
> consistent with both mdmon and mdopen.  If we don't, we will fail to
> create our mapfile.

I thought udev always created the directory if it was needed, and always
removed it if it became empty after deleting an entry.  But I have no strong
basis for believing that.

However I do think that mdadm should create the directory in this case - not
any parents, but if they exist and are writeable, then create the directory.

So I modified you patch to do that when creating the mapfile (not when
reading it).

> 
> Third: mdadm-3.1.2-rebuild.patch
> Problem: The above issue pointed out a different issue.  Specifically,
> if we can't open our mapfile, then we call RebuildMap, and at the end of
> the rebuild, we trigger a new change event on the raid device.  Well, if
> the write of the new map file failed because the directory we wanted to
> write into didn't exist, this creates an infinite loop where udev calls
> mdadm, mdadm fails to open file, mdadm rebuils map, mdadm fails to write
> new map, but mdadm triggers a change event to cause udev to rerun mdadm
> on the belief that the map file *was* updated.  So, if we fail to write
> the new mapfile, don't signal a change event, let the situation drop.
> This avoids the infinite loop.

Very appropriate - thanks.

> 
> Fourth: mdadm-3.1.2-mapname.patch
> Feature: If we are able to easily select the location of the mapfile via
> the use of ALT_RUN at compile time, it makes sense to also be able to
> set the filename.  This way you can make it something obvious such as
> /dev/md + md-device-map which makes the file name both unlikely to
> conflict with a device name (where as I could see map conflicting in
> certain specialized scenarios, like the array holding map data at the
> local governmental office) and obvious in purpose.
> 
> 

Seems reasonable.  I've included that patch too.

Thanks a lot,
NeilBrown
