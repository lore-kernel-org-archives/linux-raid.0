From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 08:05:54 -0500
Message-ID: <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com>
	 <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48FD94F9.3060400@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 21, 2008 at 3:38 AM, David Greaves <david@dgreaves.com> wrote:
> Mario 'BitKoenig' Holbe wrote:
>> Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
>>> I was wondering about proactive drive replacement.
>> [bitmaps, raid1 drive to replace and new drive, ...]
>>
>> I belive to remember a HowTo going over this list somewhere in the past
>> (early bitmap times?) which was recommending exactly your way.
>>
>>> The problem I see with the above is the creation of the raid1 which
>>> overwrites the superblock. Is there some way to avoid that (--build?)?
>>
>> You can build a RAID1 without superblock.
>
> How nice, an independent request for a feature just a few days later...
>
> See:
>   "non-degraded component replacement was Re: Distributed spares"
> http://marc.info/?l=linux-raid&m=122398583728320&w=2

D'oh!  I had skipped that thread before. There are differences, however minor.

> It references Dean Gaudet's work which explains why the above scenario, although
> it seems OK at first glance, isn't good enough.
>
> The main issue is that the drive being replaced almost certainly has a bad
> block. This block could be recovered from the raid5 set but won't be.
> Worse, the mirror operation may just fail to mirror that block - leaving it
> 'random' and thus corrupt the set when replaced.
> Of course this will work in the happy path ... but raid is about correct
> behaviour in the unhappy path.

In my case I was replacing a drive because I didn't like it.

-- 
Jon
