From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 16:20:06 -0700
Message-ID: <49F78F26.2040909@zytor.com>
References: <1240574900.4507.2076.camel@ezra>	<87hc0axhg9.fsf@frosties.localdomain>	<49F68CE0.2010906@zytor.com>	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>	<1240957153.18303.689.camel@ezra> <18935.35747.471257.202356@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.35747.471257.202356@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> That only leaves the question of what happens when a spare is added to
> the array - how does the grub data get written to the space on the
> spare.
> I would rather that grub were responsible for this, than for md to
> treat that unused space as RAID1.
> We already have a notification system based on "mdadm --monitor" to
> process events.  We could possibly plug grub in to that somehow so
> that it gets told to re-write all it's special blocks every time
> something significant changes in the array.
> 

I have multiple issues with this concept (including promoting Grub2, but
let's not get into that.)

For this to be reliable, there is only one sensible configuration, which
is for /boot to be a RAID-1, which is better handled by -- guess what --
partitioning systems; and we already have quite a few of those that work
just fine, thank you.  Otherwise there WILL be configurations -- caused
by controller failures if nothing else -- that simply will not boot even
though the system is otherwise functional.  Promoting this kind of stuff
is criminally stupid.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

