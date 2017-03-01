From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Wed, 1 Mar 2017 15:02:31 +0000
Message-ID: <58B6E287.9020804@youngman.org.uk>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
 <58B2137B.6070608@youngman.org.uk>
 <5172e2ab-e193-477b-52c4-86fbab0d52fe@turmel.org>
 <58B21987.6060604@youngman.org.uk>
 <657e80e9-b1f5-1f58-a4d0-6cbc4cc44927@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <657e80e9-b1f5-1f58-a4d0-6cbc4cc44927@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/02/17 00:07, Phil Turmel wrote:
>> Because to do so doesn't make sense? Or because nobody's bothered to do
>> > it? I get grumpy when people implement corner cases without bothering to
>> > implement the logically sensible options - bit like those extremely
>> > annoying dialog boxes that give you three choices, "yes", "no", "yes to
>> > all". What about no to all?

> Because while disconnected, and the array begins accumulating
> write-intent bits indicating where any disconnected device is out of
> date, the array has no way to know what writes are happening to that
> member.  And therefore any re-add will introduce unknowable corruptions.
>  There is no way to control what writes happen to that member, and
> drives don't naturally keep a log of writes that have happened.  The data to
> safely do what you want simply doesn't exist.  Your only known safe
> choice is to disable write-intent bitmaps, forcing complete resync on
> --re-add.

Sorry to drag this up again, but where are these write intent bits going
to come from? And it's a backup. Why am I going to re-add, unless I'm
going to wipe the old backup and create a new one?
> 
>> > I feel like mirror-raid is perfect for doing backups.

> Your feelings are wrong.  Sorry.  LVM is the perfect tool because it
> entirely controls the snapshot and doesn't have to re-add it.
> 
I think we're talking at cross-purposes here :-) You're talking about
creating a snapshot and backing it up. I'm talking about creating a
mirror, which IS the backup.

VERY different technique, same end result.

And your way is more complicated - more room for sys-admin cock-up :-)

>> > I take your point
>> > that linux hasn't implemented that feature (particularly well), but
>> > surely it's a feature that *should* be there. I know I know - "patches
>> > welcome" :-)

> Good luck creating the necessary data from thin air.  It's not a
> question of writing patches.
> 
mdadm --build /dev/mdbackup --device-count 2 /dev/md/home missing
... hotplug sd-big ...
madam /dev/mdbackup --add /dev/sd-big
... wait for sync to finish ...
mdadm --stop mdbackup
... unplug sd-big ...

You've made me think about it deeper than before - thanks - and I can
think of at least one potential show-stopper, but write-intent bitmaps
and missing raid data are most definitely not it :-)

And why do I think my way is "better" (for certain values of "better"
:-) - because your way only works if it was planned in advance. My way -
if the show stopper isn't - will work on ANY running system whether
planned or not. That said, my problem probably is a show stopper :-(

Cheers,
Wol
