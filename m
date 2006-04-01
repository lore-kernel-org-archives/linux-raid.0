From: Mike Hardy <mhardy@h3c.com>
Subject: Re: addendum: was Re: recovering data on a failed raid-0 installation
Date: Fri, 31 Mar 2006 21:27:18 -0800
Message-ID: <442E0F36.2050606@h3c.com>
References: <200603290526.k2T5Qmp14592@www.watkins-home.com> <200603311458.54083.technomage-hawke@cox.net> <442DB358.1010402@h3c.com> <200603312156.26176.technomage-hawke@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200603312156.26176.technomage-hawke@cox.net>
Sender: linux-raid-owner@vger.kernel.org
To: Technomage <technomage-hawke@cox.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Well, honestly I'm not really sure. I've never done this as I only use
the redundant raid levels, and when they're gone, things are a complete
hash and there's no hope. In fact, with raid-0 (striping, right? not
linear/append?) I believe you are in the same boat. Each large file will
have half its contents on the disk that died. So really, there's very
little hope.

Anyway, I'll try to give you pointers to what I would try anyway, with
as much detail as I can.

First, you just need to get the raid device up. It sounds like you are
actually already doing that, but who knows. If you have one drive but
not the other, you could make a sparse file that is the same size as the
disk you lost. I know this is possible, but haven't done it so you'll
have to see for yourself - I think there are examples in linux-raid
archives in reference to testing very large raid arrays. Loopback mount
the file as a device (losetup is he command to use here) and now you
have a "virtual" device of the same size as the drive you lost.

Recreate the raid array using the drive you have, and the new "virtual"
drive in place of the one you lost. It's probably best to do this with
non-persistent superblocks and just generally as read-only as possible
for data preservation on the drive you have.

So now you have a raid array.

For the filesystem, well, I don't know. That's a mess. I assume it's
possible to mount the filesystem with some degree of force (probably a
literally -force argument) as well as read-only. You may need to point
at a different superblock, who knows?

You just want to get the filesystem to mount somehow, any way you need
to, but hopefully in a read-only mode.

I would not even attempt to fsck it.

At this point, you have a mostly busted filesystem on a fairly broken
raid setup, but it might be possible to pull some data out of it, who
knows? You could pull what looks like data but is instead garbage to
though - if you don't have md5sums of the files you get (if you get any)
it'll be hard to tell without checking them all.

Honestly, that's as much as I can think of.

I know I'm just repeating myself when I say this, but raid is no
replacement for backups. They have different purposes, and backups are
no less necessary. I was sorry to hear you didn't have any, because that
probably seals the coffin on your data.

With regard to people recommending you get a pro. In this field (data
recovery) there are software guys (most of the people on this list) that
can do a lot while the platters are spinning and there are hardware guys
(the pros I think most people are talking about). They have physical
tools that can get data out of platters that wouldn't spin otherwise.

There's nothing the folks on the list can do really other than recommend
seeing someone (or shipping the drive to) one of those dudes. When you
get the replacement drive back from them with your data on it, then
we're back in software land and you may have half a chance.

That said, it sounded like you had already tried to fsck the filesystem
on this thing, so you may have hashed the remaining drive. It's hard to
say. Truly bleak though...

-Mike

Technomage wrote:
> mike.
> 
> given the problem, I have a request.
> 
> 
> On Friday 31 March 2006 15:55, Mike Hardy wrote:
> 
>>I can't imagine how to coax a filesystem to work when it's missing half
>>it's contents, but maybe a combination of forcing a start on the raid
>>and read-only FS mounts could make it hobble along.
> 
> 
> we will test any well laid out plan. 
> 
> lay out for us (from beginning to end) all the steps required, in your test. 
> do not be afraid to detail the obvious. it is better that we be in good 
> communication than to be working on assumptions. it will save you a lot of 
> frustration trying to correct for our assumptions, if there are none. 
> 
> tmh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
