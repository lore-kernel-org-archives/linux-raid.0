From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 15 Jun 2004 09:39:49 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16590.14149.960504.534126@cse.unsw.edu.au>
References: <40198E85.29EBC8E0@SteelEye.com>
	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
	<4027E342.D02202F1@SteelEye.com>
	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>
	<402D3A86.97CF894F@SteelEye.com>
	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>
	<4048F9AA.1BBD67F@SteelEye.com>
	<406B1024.7BF88C@SteelEye.com>
	<16528.49083.998593.199805@cse.unsw.edu.au>
	<40C6273B.2060200@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday June 8
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

On Tuesday June 8, paul.clements@steeleye.com wrote:
> Neil,
> 
> Here's the latest patch...it supports bitmaps in files as well as block 
> devices (disks or partitions), contrary to what I had stated in my 
> previous e-mail. I've tried to address all the issues you've pointed 
> out, and generally cleaned up and fixed the patch some more...details 
> below...
> 
> Patches available at:
> 
> bitmap patch for 2.6.6:
>    http://dsl2.external.hp.com/~jejb/md_bitmap/md_bitmap_2_32_2_6_6.diff
> 
> mdadm patch against v1.6.0:
>    http://dsl2.external.hp.com/~jejb/md_bitmap/mdadm_1_6_0-bitmap.diff
> 
> (the normal parisc-linux.org URLs are not working right now, for some 
> reason...)

Unfortunately, these dsl2 URLs aren't working today - I should have
grabbed the patches earlier.  I'll check again later in the day.

> 
> >>1) an is_create flag was added to do_md_run to tell bitmap_create
> >>whether we are creating or just assembling the array -- this is
> >>necessary since 0.90 superblocks do not have a UUID until one is
> >>generated randomly at array creation time, therefore, we must set the
> >>bitmap UUID equal to this newly generated array UUID when the array is
> >>created
> > 
> > 
> > I think this is the wrong approach.  You are justifying a design error
> > by reference to a previous design error.
> > I think user-space should be completely responsible for creating the
> > bitmap file including setting the UUID.
> > Either
> >   1/ add the bitmap after the array has been created.
> > or
> >   2/ Create the array in user-space and just get the kernel to
> >     assemble it (this is what I will almost certainly do in mdadm
> >     once I get around to supporting version 1 superblocks).
> 
> I could not find another way to make this work with the existing code, 
> so this remains as is.

I guess that means you (or someone) needs to write some code.
Creating the array, including allocating the UUID, in userspace is
trivial.  Just make some superblocks and write them into the right
location in each device.   Then assemble the array as you would any
pre-existing array.

> 
> > and the worst part about it is that the code doesn't support what I
> > would think would be the most widely used and hence most useful case,
> > and that is to store the bitmap in the 60K of space after the
> > superblock.
> 
> Unfortunately, this type of setup performs rather abysmally (generally, 
> about a 5-10x slowdown in write performance). If you think about what is 
> happening to the disk head, it becomes clear why. In fact, having the 
> intent log anywhere on the same physical media as the array components 
> gives very bad performance. For this reason, I have not taken extra 
> steps to support this configuration. If anyone is curious, this type of 
> setup can be tested using device mapper (but not loop, because loop does 
> not have the correct sync semantics) to map that area of the disk as a 
> separate device and use it as a bitmap.

Ahhh... this explains a comment you made some time ago where I thought
performance would be pretty poor and you said it wasn't.  I was
imagining the bitmap in the same device as the array and you weren't.

I think I mentioned at the time that this could be addressed by using
"plugging".

When a write request arrives for a block that isn't flagged as
"dirty", we flag it 'dirty' and put the request on a queue.  When an
"unplug" request is made, we flush all updates to the "dirty" bitmap,
and then release the queued write requests.  There could still be a
noticeable performance hit, but it should be substantially less than
with the current code.


Everything else you mentioned sounds good.  When I manage to get a
copy of the patch I'll comment further.

NeilBrown
