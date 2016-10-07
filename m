From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 13:21:51 +0200
Message-ID: <20161007112151.GA4405@metamorpher.de>
References: <57F6DF18.40703@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57F6DF18.40703@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 07, 2016 at 02:32:40AM +0300, Dark Penguin wrote:
> why not just return a read error instead?

You make it sound like it solves all problems, but it does not.
Errors are just not part of the concept anywhere really.

If a filesystem encounters one, it might flip into read only mode;
if a program encounters one it might do whatever.
You still have a huge data loss, corrupt databases, et cetera.

Even so, is that not what you have with "bad block log" enabled, 
within reason? I disable it everywhere. I want my disks kicked.

Using cosmetics to hide errors only works to a certain limit. 
In the end, RAID only works if the disks work. RAID 5 with 
two dead disks is dead, no way to get around that. Disks go bad 
and need to be replaced, if you don't do that, you'll just fail 
even more horribly later on.

> I believe this is the dream of everyone who had ever 
> dealt with RAIDs.

My dream is different. I don't want errors. I want it to work. ;)
And it does, as long as you make sure your disks are healthy.

And if you make every effort to keep broken disks in your arrays, 
it just won't work. All promises are off - RAID promises to survive 
one or two dead disks, but that's only if all other disks are in 
perfect working order for the time it takes to rebuild.

Your disk produces read errors, or needs 3 minutes to read a single sector, 
what use is it to anyone? I'm not letting those disks stay, no matter how 
many more people preach that "read errors are normal". No. They're not. 
Such disks are utter and complete trash and have to go.

Don't wait for MD to kick disks out either. Check your disks. 
Actually replace them if they have errors. Most RAIDs die due 
to people not monitoring their disks, or delaying replacements.

Replacing disks costs money but that is the price you have to pay 
for the luxury of using RAID (especially at home) in the first place. 
When buying a RAID system, the money for the next replacement disk 
should always be planned into your budget. If you max it out or 
overdraw your budget for those fancy enterprise RAID disks, 
you'll find they die just the same.

Also make backups. RAID never replaces backups.

Regards
Andreas Klauer
