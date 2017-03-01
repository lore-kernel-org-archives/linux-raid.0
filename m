From: <ian_bruce@mail.ru>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Wed, 1 Mar 2017 05:05:47 -0800
Message-ID: <20170301050529.5978de82.ian_bruce@mail.ru>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
        <87y3wsp47n.fsf@notabene.neil.brown.name>
        <20170228022513.2cf5445a.ian_bruce@mail.ru>
        <87mvd6oy8n.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mvd6oy8n.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 01 Mar 2017 07:29:28 +1100
NeilBrown <neilb@suse.com> wrote:

> Thanks.  That makes it easy.
> Test works with my patch applied.

Thanks for fixing that.

If anybody is curious, the application for this capability is as
follows. For live systems running from a USB flashdrive, we need to
loop-mount an ext4 filesystem image from the fat32-formatted flashdrive.
Unfortunately, the maximum file size on fat32 is 4GB, which is a severe
limitation, when 128GB flashdrives are commonly available.

The solution is to split the ext4 image into multiple sub-4GB chunks,
associate a /dev/loop device with each of those files, have mdadm turn
those into a single RAID device, and mount that as the ext4 filesystem.
It is preferable to use non-metadata, linear-mode RAID for this, because
we can then convert back and forth between the single filesystem image
and its constituent chunks using the non-privileged utilities "cat" and
"split". With a maximum of 27 RAID component devices, the maximum
filesystem size would be 108GB, which is not quite a complete solution.


On Fri, 24 Feb 2017 15:46:19 -0500
Phil Turmel <philip@turmel.org> wrote:

> Note that build mode doesn't support a bunch of other MD raid features
> either, like all of the parity raid levels. That it doesn't support
> v1+ metadata isn't a surprise, and isn't the only legacy feature that
> only uses legacy metadata (built-in kernel auto-assembly gets the most
> whining, actually).

> If you think its trivial to implement --build with v1.x metadata, go
> right ahead. Post your patches for review.

I haven't tested "mdadm --build" with parity RAID myself (although the
/dev/loop trick would probably suffice for that too), but if this is so,
would the change to provide that be as simple as the patch to remove the
27-component limitation? (Although I suppose that unlike linear mode,
the component devices for parity mode would have to be initialized with
consistent data, first.)

Somebody might find a use for non-metadata, parity-mode RAID, if it were
available.


-- Ian Bruce
