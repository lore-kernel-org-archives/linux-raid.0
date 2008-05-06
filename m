From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Tue, 6 May 2008 07:58:10 -0400
Message-ID: <170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18464.134.236488.251879@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18464.134.236488.251879@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Tue, May 6, 2008 at 2:53 AM, Neil Brown <neilb@suse.de> wrote:
> On Wednesday April 2, snitzer@gmail.com wrote:
>  > resync via bitmap if faulty's events+1 == bitmap's events_cleared
>  >
>  > For more background please see:
>  > http://marc.info/?l=linux-raid&m=120703208715865&w=2
>  >
>  > Without this change validate_super() will prevent the previously faulty
>  > member from recovering via bitmap, e.g.:
>
>  I can't help thinking that you are misinterpreting something.  I don't
>  think there is a clean->dirty transition happening here.
>  You could confirm this by using --examine on both devices after the
>  messy shutdown and before re-assembling the array.
>
>  Even allowing for that possible confusion, I cannot quite see what is
>  going on.
>  It is fairly clear from the event counts that the NBD device is marked
>  clean, but if this is happening at array-shutdown time, I cannot see
>  why md would try to write to the NBD device and thereby detect an
>  error...
>
>  Do you have an internal bitmap or a bitmap in an external file?
>
>  In general, I would not like to make decisions based on the
>  oddness/evenness of the event counter.  I consider that to be an
>  internal implementation detail.  I am happy to make decisions based on
>  a difference-of-1.  I need to understand the big picture first though.

Hi Neil,

I definitely could be misinterpreting something.  However, I did
determine that if the write-mostly NBD member of the raid1 becomes
degraded while writing to the raid1 it frequently has an 'events' that
is one less than the 'events_cleared' (of the local raid1 member that
the array gets reassembled with first).  The events indicate the NBD
member is clean and the local member is dirty.

I'm using internal bitmaps.  I've focused on the even->odd
(clean->dirty) transition to rationalize the safety of allowing the
NBD member to be off by one _and_ clean.  That could easily be
superficial but it seems significant.

It looks like bitmap_update_sb()'s incrementing of events_cleared (on
behalf of the local member) could be racing with the fact that the NBD
member becomes faulty (whereby making the array degraded).  This
allows the events_cleared to reflect a clean->dirty transition last
occurred before the array became degraded.  My reasoning is: If it was
a clean->dirty transition the bitmap still has the associated dirty
bit set in the local member's bitmap, so using the bitmap to resync is
valid.

thanks,
Mike
