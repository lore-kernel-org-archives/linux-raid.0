From: "NeilBrown" <neilb@suse.de>
Subject: Re: Hot-swapping: what's that? (and 3ware 9650SE)
Date: Wed, 19 Aug 2009 13:28:21 +1000 (EST)
Message-ID: <28ace66d03047be599f12a6ce043ff71.squirrel@neil.brown.name>
References: <4A8AFC5F.3070108@shiftmail.org>
    <c268e4660908181549k4ce5082bm33862349f220e848@mail.gmail.com>
    <4A8B63F4.7090108@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A8B63F4.7090108@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, August 19, 2009 12:31 pm, John Robinson wrote:
> On 18/08/2009 23:49, Drew wrote:
>>> One question remains: ok but what is hot-swap anyway?
> [...]
>> In the context of RAID, "hot swap" typically refers to any system
>> which allows drives to be changed out on a live system without having
>> to interact with the operating system beforehand. IBM's ServeRAID
>> controllers are a good example. Replacing a failed drive is as simple
>> as walking over to the server, pulling out the drive identified as
>> defective, and inserting a replacement. The raid controller recognizes
>> the replacement and begins to integrate it back into the array within
>> 30secs.
>
> By the above definition, md RAID doesn't do hot swap. My hardware does
> hot swap (ICH10R SATA, SuperMicro drive cage), and I just tried yanking
> one of my drives:

Correct.  mdraid does not do hotswap by that definition.

However all the the bits you need to implement hotswap exist, you just
need some scripts to tied it together.
Specifically, you need to write something that udev runs whenever it
sees a new device.  Somehow it has to decide what should be done with
that device, and do it.
The "do it" part would simply be a call the mdadm, possible "mdadm --add ..."
The "Somehow ... decide" is the tricky part.  What you want probably isn't
what I want or what someone else wants.

If I were to integrate hotswap in to md raid, I would probably connect
it to the "mdadm --incremental" functionality.
I would add some sort of "policy" information to /etc/mdadm.conf
telling mdadm that if it found an unrecognised device on some
particular controler (or on any controller), it should add it
to some particular 'spare group'.

That would just be very basic hotswap.  It has been suggested earlier in this
thread that you might like a RAID1 to convert to a RAID5 as soon as a
third drive was available.  This is functionality I would probably
put in "mdadm --monitor" (if at all).  Again there would need to be
some policy rule in /etc/mdadm.conf, maybe describing the ideal
configuration of an array, which would include minimum number of spares,
maximum number of disks in the array, number of disks at which to
switch from RAID5 to RAID6.

But before doing something like this, I would really like someone
to try it out themselves with a few ad-hoc scripts and report the
results.  There is nothing like real concrete experience to give
useful guidance to designing this sort of functionality.

NeilBrown

