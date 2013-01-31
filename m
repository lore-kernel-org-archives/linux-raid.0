From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 14:19:18 -0700
Message-ID: <A40C3332-6A9E-4832-BBF2-860E3D1BF00A@colorremedies.com>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <510ABC1E.6060308@evilazrael.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510ABC1E.6060308@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Please reply to the list, not just to me personally.


On Jan 31, 2013, at 11:46 AM, Christoph Nelles <evilazrael@evilazrael.de> wrote:
> 
> Am 31.01.2013 18:46, schrieb Chris Murphy:
>> 
>> This looks like a write error, resulting in md immediately booting
>> the drive. There's little point in using this drive again.
> 
> Sure, but i think in the current half-rebuilt state, i will need the
> striped data on that disk, am i correct about that?

Only if you have no backup, and you want to extract what you can.

> Okay, a badblocks running in read-only mode may not be better than just
> dd' ing the drive to /dev/null, but at least I can see if there more
> read errors.

I don't see the point at all of learning about more read errors. This changes your strategy how? The array has failed. Either you want to backup what you can, or you don't. In either case, ultimately you're going to be creating a new array from scratch after you've tested and replaced the underlying drives.

> I am currently checking all drives and if that succeeds, i
> will try this safe write-read test badblocks offers. Just want to be
> safe that won't do any additional damage.

I think this helps you exactly zero.

> My current goal is to get access to all of my data. Or at least to as
> much data as possible. Then I can replace HDDs and upgrade to RAID6.

I'd stop wasting time with badblocks. Either the array will assemble, or it won't. Maybe someone will respond whether assuming clean is a good idea to avoid any writes to the disks, which has a decent chance of causing sdg to be bounced again, mount the file system read only; and extract what you can.

It seems to me data extraction the priority. Once you have the backup, you can test your individual array components, not now.

Chris Murphy