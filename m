From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm: how to move superblock 1.0 on reduced components
Date: Fri, 17 Feb 2017 10:36:33 +0000
Message-ID: <58A6D231.5090202@youngman.org.uk>
References: <20170215234114.GL28234@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170215234114.GL28234@gmx.com>
Sender: linux-raid-owner@vger.kernel.org
To: "G.raud" <graud@gmx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/02/17 23:41, G.raud wrote:
> I cannot find information about this topic on the web.

I'll add a little more for you to think about ... :-) Have you looked at
the raid wiki? In particular, have you read this section?

https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Array_internals_and_how_it_affects_mdadm
> 
> Reducing the size of the components of an md array keeps the superblock
> 1.0 at the same position (which avoids data corruption and maybe is
> required for md to find it).  However how can one then reduce the size
> of the underlying device without losing the superblock?
> 
> In an array with redundancy re-addind reduced components one after the
> other is a rather safe solution, I suppose, but it is time consuming.
> Would it be possible to update the superblock version by doing that,
> either by mixing different superblock versions by giving --metadata with
> --add or by modifying the partitions defining the re-added components so
> that the new devices start at the right offset for a superblock 1.2 (and
> later using the following solution, re-creating the array with the
> original partitions and a 1.2 superblock at the right offset with
> --data-offset)?

I don't believe you can mix different meta-data versions. Almost
certainly you can't mix 0.9 and 1, and I doubt you can mix the different
v1 versions.
> 
> Re-creating all components after a reduction of the underlying devices
> seems possible by using --assume-clean.  What to look for to avoid data
> loss?
> 
> mdadm already supports enlarging a 1.0 component, which requires moving
> the superblock, so the code to reduce one would probably not require
> much efforts.  Could it be added in the future?

Are you sure it doesn't do it already? You will probably find (I can't
say for sure) that mdadm adjusts the size, calculates the new position,
and moves the superblock without actually being aware whether the space
is getting larger or smaller. I know elsewhere "grow" actually means
"make bigger or smaller" - I would be surprised if that's not true here.
> 
> I would like to attempt to move the superblocks 1.0 manually, but I lack
> some information:
> 
> 1) Should the reserved space before the superblock be moved along?
> 
> 2) Is there metadata inside a superblock 1.0 to update after the move
>    (that another program would not correct automatically)?
> 
> 3) How is the superblock detected?  Is there only one position possible
>    for a given chunk size on a given component size?  Should the
>    remaining (padding) sectors of the underlying device be zeroed?
> 
If you're going to move them manually (whatever that means) why not look
at fixing mdadm to do it for you? I believe all the v1 superblocks are
identical, differing only in their location, so if you look at how mdadm
changes the size of a v1.0 that should tell you most of what you need to
know.

I'd just check whether there is sufficient space at the start to move
the superblocks. If there isn't fail with "no space, use --data-offset
to create space before moving the superblock". If there is the space,
just do it.

If you're mad enough to use a hex editor, or dd or whatever to move
stuff around, please write it up :-) I can then add it to the wiki as a
pointer for anyone who wants to modify mdadm.

And while it may be a little extra work, if you're fixing mdadm to move
superblocks around, please make it able to convert any v1 to any other
v1, don't do just your specific requirement. The extra work is hopefully
minimal and would be much appreciated. I personally hate it when I come
across stuff that "sometimes works, sometimes doesn't" for no obvious
reason other than the author fixed his specific problem rather than a
generic solution. Okay, people shouldn't want to convert v1.2 to v1.1 or
v1.0, but you can bet your bottom dollar someone will come up with some
weird and justifiable reason to do so ...

Cheers,
Wol

