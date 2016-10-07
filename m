From: Phil Turmel <philip@turmel.org>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 10:43:49 -0400
Message-ID: <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161007112151.GA4405@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Dark Penguin <darkpenguin@yandex.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Andreas,

On 10/07/2016 07:21 AM, Andreas Klauer wrote:
> On Fri, Oct 07, 2016 at 02:32:40AM +0300, Dark Penguin wrote:
>> why not just return a read error instead?
> 
> You make it sound like it solves all problems, but it does not.
> Errors are just not part of the concept anywhere really.

That's not strictly true. The majority of read errors on large modern
drives are fixable by writing over the troublesome sector.  That may or
may not relocate the sector to the drive's spare area.  Read error
locations that haven't yet been overwritten are identified in the drive
firmware as "Pending Relocations", since the drive doesn't yet know if
the problem is a true media defect or just a write error (power
transient during write, whatever).

Since brand new drives almost never have errors, people assume that's
normal.  Get three or four years in and you see that's not true.  In my
experience, when actual relocations hit double digits, it's time to
replace the drive.  The drive is still operating within spec, though --
it won't be a warranty replacement.

> If a filesystem encounters one, it might flip into read only mode;
> if a program encounters one it might do whatever.
> You still have a huge data loss, corrupt databases, et cetera.

Concur.

> Even so, is that not what you have with "bad block log" enabled, 
> within reason? I disable it everywhere. I want my disks kicked.

I want my disks *fixed* if possible, not kicked.  If they're kicked, the
rest of the good data on that disk is unavailable for keeping my array
running.  I want to see the relocations growing in my daily logwatch
reports so I can use mdadm --replace to maintain the array without *any*
loss of redundancy.

> Using cosmetics to hide errors only works to a certain limit. 
> In the end, RAID only works if the disks work. RAID 5 with 
> two dead disks is dead, no way to get around that. Disks go bad 
> and need to be replaced, if you don't do that, you'll just fail 
> even more horribly later on.

Concur.  We seem to differ on where to draw the line on "bad".

> Your disk produces read errors, or needs 3 minutes to read a single sector, 
> what use is it to anyone? I'm not letting those disks stay, no matter how 
> many more people preach that "read errors are normal". No. They're not. 
> Such disks are utter and complete trash and have to go.

Really?  You get rid of drives on the first read error event?  If you're
discarding them, I'll pay shipping for you to send them to me.  That
would be an especially cost effective source of drives for me. None of
the green or desktop POSes, though.  (-:  Or are you just not noticing
the read errors because MD is silently fixing them for you?

> Don't wait for MD to kick disks out either. Check your disks. 
> Actually replace them if they have errors. Most RAIDs die due 
> to people not monitoring their disks, or delaying replacements.

Yup.

> Replacing disks costs money but that is the price you have to pay 
> for the luxury of using RAID (especially at home) in the first place. 
> When buying a RAID system, the money for the next replacement disk 
> should always be planned into your budget. If you max it out or 
> overdraw your budget for those fancy enterprise RAID disks, 
> you'll find they die just the same.

Enterprise drives are easily justified for heavily loaded arrays in a
small shop.  NAS drives are just fine for small business and home media
servers.  Green and modern desktop drives are utterly unsuited to raid duty.

> Also make backups. RAID never replaces backups.

Indeed.

Phil
