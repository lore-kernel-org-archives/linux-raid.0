From: "NeilBrown" <neilb@suse.de>
Subject: RE: md extension to support booting from raid whole disks.
Date: Sun, 3 May 2009 14:25:52 +1000 (EST)
Message-ID: <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 3, 2009 11:33 am, Leslie Rhorer wrote:
>> First thing is, DO NOT boot from raid5/6. It's pointless anyway.
>
> I agree.

I don't.
I think it is very valuable for people to share their experiences
of what works and what doesn't.  Of what problem situations arise
and what solutions seem effective.  It is even good to give advice
when advice is sought.
But to assume that the thing which works best for you will always
work for everyone else - or vice versa - is wrong.   And people seem
to be appearing close to that assumption.

>
>> Summing up, I don't get, why would anybody really want to boot from
>> raid5
>> or 6.
>
> Well, I can see the reasons, but to my mind they are outweighed by the
> problems inherent in doing so and the fact the benefits are minimal.
>

You are very welcome to share what you see as the inherent problems.
But please be aware that others may see benefits that you do not.


> With hard drives being so inexpensive, I see no reason not to have
> separate
> boot drive or mirrored set and data devices.

Yes, hard drives are cheaper than they once were.  But they still
aren't free.  And they do consume measurable volume and current.

If I happen to have a box which has only got room for 4 drives, then
I'm not going to use two of them just for boot, nor am I going to
plug in external drives with all the risks associated with them.

My own "ideal" would be
 - simple boot loader in first sector of every drive that loaded a
   'second stage' linearly off the early sectors of the disk.
 - the 'second stage' is a linux kernel plus initramfs which finds
   the root filesystem loads the final kernel and initramfs, and
   uses kexec to boot into it.

Thus the final stage of the boot loader can understand any filesystem,
any raid level, any combination of controllers.

The area that stores the second stage would be written rarely, and
always written as a whole - no incremental updates.  So much of the
power of md/raid1 would not be necessary.  Having some tool that
installed the boot loader and second stage on every bootable device would
seem an adequate solution.
Whether this space were kept free by traditional partitioning,
or by the filesystem or raid or whatever "knowing" to leave the first
few meg free is of relatively little interest to me.  I can see advantages
both ways.

While that would be my ideal, I'm quite happy to support other people in
experimenting with other approaches.  It is by being open to making mistakes
and learning from them that we grow.

So I still plan to offer a "--reserve-space=2M" option for mdadm to
allow the first 2M of each device to not used for raid data.  Whether
any particular usage of this option is viable or not, is a different
question altogether.

NeilBrown

