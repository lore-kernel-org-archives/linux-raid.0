From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Mon, 19 May 2008 00:33:58 -0400
Message-ID: <170fa0d20805182133o46501cc4va81b087fb6b417bf@mail.gmail.com>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18464.134.236488.251879@notabene.brown>
	 <170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	 <18466.39418.578722.92979@notabene.brown>
	 <170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	 <18467.43895.220708.254814@notabene.brown>
	 <170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	 <18467.59565.676987.926988@notabene.brown>
	 <170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
	 <18477.30199.992302.271647@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756152AbYESEeU@vger.kernel.org>
In-Reply-To: <18477.30199.992302.271647@notabene.brown>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Fri, May 16, 2008 at 7:54 AM, Neil Brown <neilb@suse.de> wrote:
> On Friday May 9, snitzer@gmail.com wrote:
>> On Fri, May 9, 2008 at 2:01 AM, Neil Brown <neilb@suse.de> wrote:
>> >
>> > On Friday May 9, snitzer@gmail.com wrote:
>>
>> >  > Unfortunately my testing with this patch results in a full resync.
...
>> >  diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
>> >  --- .prev/drivers/md/bitmap.c   2008-05-09 11:02:13.000000000 +1000
>> >  +++ ./drivers/md/bitmap.c       2008-05-09 16:00:07.000000000 +1000
>> >
>> > @@ -465,8 +465,6 @@ void bitmap_update_sb(struct bitmap *bit
>> >         spin_unlock_irqrestore(&bitmap->lock, flags);
>> >         sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
>> >         sb->events = cpu_to_le64(bitmap->mddev->events);
>> >  -       if (!bitmap->mddev->degraded)
>> >  -               sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
>>
>> Before, events_cleared was _not_ updated if the array was degraded.
>> Your patch doesn't appear to maintain that design.
>
> It does, but it is well hidden.
> Bits in the bitmap are only cleared when the array is not degraded.
> The new code for updating events_cleared is only triggered when a bit
> is about to be cleared.

Hi Neil,

Sorry about not getting back with you sooner.  Thanks for putting
significant time to chasing this problem.

I tested your most recent patch and unfortunately still hit the case
where the nbd member becomes degraded yet the array continues to clear
bits (events_cleared of the non-degraded member is higher than the
degraded member).  Is this behavior somehow expected/correct?

This was the state of the array after the nbd0 member became degraded
and the array was stopped:

# mdadm -X /dev/nbd0 /dev/sdq
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : 7140cc3c:8681416c:12c5668a:984ca55d
          Events : 2642
  Events Cleared : 2642
           State : OK
       Chunksize : 128 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 52428736 (50.00 GiB 53.69 GB)
          Bitmap : 409600 bits (chunks), 1 dirty (0.0%)

        Filename : /dev/sdq
           Magic : 6d746962
         Version : 4
            UUID : 7140cc3c:8681416c:12c5668a:984ca55d
          Events : 2646
  Events Cleared : 2645
           State : OK
       Chunksize : 128 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 52428736 (50.00 GiB 53.69 GB)
          Bitmap : 409600 bits (chunks), 1 dirty (0.0%)


At the time the nbd0 member became degraded events_cleared was 2642.
What I'm failing to understand is how sdq's events_cleared could be
allowed to increment higher than 2642?

I've not yet taken steps to understand/verify your test script.  As
such I'm not sure it models my test scenario yet.

Mike
