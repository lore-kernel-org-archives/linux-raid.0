From: Mason Loring Bliss <mason@blisses.org>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Tue, 21 Jan 2014 12:19:43 -0500
Message-ID: <20140121171943.GC6553@blisses.org>
References: <52DE3B56.2000506@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52DE3B56.2000506@hesbynett.no>
 <21213.43338.397566.928634@tree.ty.sabi.co.uk>
 <20140121084617.582f9b75@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 21, 2014 at 08:46:17AM +1100, NeilBrown wrote:

> ars technica recently had an article about "Bitrot and atomics COWs: Inside
> "next-gen" filesystems."
[...]
> That is where I stopped reading because that is *not* how bitrot happens.

I'm not finding the specific things I've read to this effect, and some of it
was on ephemeral media (IRC), but one of the justifications I've seen for the
ZFS/BTRFS approach is that some drives might not consistently report errors.
I think it's likely the case that one is in somewhat bad trouble in that
situation, but paranoia isn't strictly a bad thing.


> i.e. that clever stuff done by btrfs is already done by the drive!

The Ars Technica article shook my faith in this a little, and I'm
appreciating the balanced view. (And, I'm spinning up smartd anywhere where
it's not now running.)



On Mon, Jan 20, 2014 at 10:55:06PM +0000, Peter Grandi wrote:

> This seems to me a stupid idea that comes up occasionally on this list, and
> the answer is always the same: the redundancy in RAID is designed for
> *reconstruction* of data, not for integrity *checking* of data,

And yet, one person's stupid is another person's glaringly obvious. The RAID
layer is the only one where you can have redundant data available from
distinct devices. If it's desired, fault-tolerance ought to exist at every
level.


> and RAID assumes that the underlying storage system reports *every* error,
> that is there are never undetected errors from the lower layer.

I wouldn't want to force extra processing and storage onto everyone, but it
seems like something that doesn't muddy the design or complicate things at
all. It seems like a perfect option for the paranoid - think of ordered data
mode in EXT4. You don't have to turn it on if you don't want it.



On Tue, Jan 21, 2014 at 10:18:14AM +0100, David Brown wrote:

> I've read your blog on this topic, and I fully agree that checksumming or
> read-time verification should not be part of the raid layer.

Can you provide a link, please?


> The ideal place is whatever is generating the data generates the checksum,
> and whatever is reading the data checks it - then /any/ error in the
> storage path will be detected.

Detected, but not corrected. Again, fault tolerance means that the system
works around errors. As has been pointed out, there are potential sources of
error at every level. It's not at all unreasonable for each layer to take
advantage of available information to ensure correct operation.

Hell, in a past life when I was working on embedded medical devices, I wrote
code to store critical variables in reprodicibly-mutated form so that on
accessing them I could verify that the hardware wasn't faulty and that
nothing was randomly spraying memory. Certainly it cost a tiny bit of extra
processing. The goal wasn't fault tolerance there, it was detection, but the
point is that we didn't have to trust the substrate, so we did what we could
to use it without trust.


> Putting the checksums in the filesystem, as btrfs does, is the next best
> thing - it is the highest layer where this is practical.

Again, depending on the goal. It's practical error detection, but doesn't add
to the reliability of the overall system at all if there's no source of
redundant data for a quorum.

-- 
The creatures outside looked from pig to man, and from man to pig, and from pig
to man again; but already it was impossible to say which was which. - G. Orwell
