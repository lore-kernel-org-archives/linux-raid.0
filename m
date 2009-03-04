From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] support for removed disks / imsm updates
Date: Thu, 5 Mar 2009 09:41:51 +1100
Message-ID: <18863.943.962566.542421@notabene.brown>
References: <1235779532.26302.32.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Friday February 27
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Friday February 27, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> This update brings:
> 
> 1/ Various imsm fixes, importantly some updates due to a clarification
> of how the Windows driver marks disk failures
> 2/ Support for handling removed disks as currently all container
> manipulations fail once a live disk is hot-unplugged.

So this is when md thinks the device is in the array, but the device
has actually been removed so with the block/dev file is missing or
empty, or the status is not 'online'..

But we only check for that if mdmon is running.  For some reason that
seems odd, but I'm not really sure.
Why do we want to treat this case differently depending on whether
mdmon is running or not?

> 3/ An initial mdmon man page
> 4/ imsm auto layout support
> 5/ Updates to --incremental in pursuit of assembling external metadata
> arrays in the initramfs via udev events

Thanks.

Most look good.
My attention was caught by Create: wait_for container creation.

I vaguely remember trying that and it didn't work.  Something about
the md array not being in the right sort of state for udev to create a
device, or something...  But I expect you have tested it so maybe I'm
remembering something else.

> 
> The one "fix" that is missing from this update is to teach mdmon to kick
> "non-fresh" drives similar to what the kernel does at initial assembly.
> I dropped the attempt after realizing I would need to take an O_EXCL
> open on the container in an awkward place.  I guess it is not necessary,
> but it is a quirk of containers that known failed drives can be allowed
> back into the container.

I always thought it was a slightly odd quirk that if you had an array
with failed drives, then stopped and restarted the array, those failed
drives would no longer be there.
My feeling is that it doesn't matter a great deal one way or the
other.  The important thing is that when mdadm describes the state of
an array, it describes it in a way that doesn't confuse people (an
area in which v1.x metadata lets us down at the moment).

> 
> Thanks to Jacek Danecki and my colleagues in Poland for identifying the
> removed disks problem and working through the regressions on this
> release.  Also along these lines you will see that I have moved
> development to github to allow more collaboration on this tree.

Yes, thanks!  I see a lot of polishing happening in this patch set
which is nice.

I had noticed you had a presence on github.  I tried playing with it
one afternoon.  It seems awkwardly slow and very poorly documented.
Then I went looking at gitorious and got distracted...

> 
> Please have a look.
> 
> Is it about time for a -devel3 release?

Yes, or a -rc1.  RSN !! :-)

For now, all these patches have been pulled and pushed to neil.brown.name/mdadm

NeilBrown
