From: "Billy Crook" <billycrook@gmail.com>
Subject: Re: Distributed spares
Date: Mon, 13 Oct 2008 17:30:49 -0500
Message-ID: <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
References: <48F3C2A1.3080607@tmr.com>
	 <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just my two cents....  Those daily smart tests or regularly running
badblocks are fine, but they're not 'real' load.  A test can't prove
everything is right, it can at best only prove it didn't find anything
wrong.  Distributed spare would exert 'real' load on the spare because
the spare disks ARE the live disks.


On a side note, it would be handy to have a daemon that could run in
the background on large raid1's, or raid6', and once a month, pull
each disk out of the array sequentially, completely overwrite it,
check it with badblocks several times, do the smart tests, etc...,
then rejoin it, reinstall grub, wait an hour and move on.  The point
being, of course, to kill weak drives off early and in a controlled
manor.  It would be even nicer if there were a way to hot-transfer one
raid component to another without setting anything faulty.  I suppose
you could make all the components of the real array be single disk
raid1 arrays for that purpose.  Then you could have one extra disk set
aside for this sort of scrubbing, and never even be down one of your
parities.  I guess I should add that onto my todo list....

-Billy

On Mon, Oct 13, 2008 at 17:11, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Mon, 13 Oct 2008, Bill Davidsen wrote:
>
>> Over a year ago I mentioned RAID-5e, a RAID-5 with the spare(s)
>> distributed over multiple drives. This has come up again, so I thought I'd
>> just mention why, and what advantages it offers.
>>
>> By spreading the spare over multiple drives the head motion of normal
>> access is spread over one (or several) more drives. This reduces seeks,
>> improves performance, etc. The benefit reduces as the number of drives in
>> the array gets larger, obviously with four drives using only three for
>> normal operation is slower than four, etc. And by using all the drives all
>> the time, the chance of a spare being undetected after going bad is reduced.
>>
>> This becomes important as array drive counts shrink. Lower cost for drives
>> ($100/TB!), and attempts to drop power use by using fewer drives, result in
>> an overall drop in drive count, important in serious applications.
>>
>> All that said, I would really like to bring this up one more time, even if
>> the answer is "no interest."
>>
>> --
>> Bill Davidsen <davidsen@tmr.com>
>> "Woe unto the statesman who makes war without a reason that will still
>> be valid when the war is over..." Otto von Bismark
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Bill,
>
> Not a bad idea; however, can the same not be acheived (somewhat) by
> performing daily/smart, weekly/long tests on the drive to validate its
> health?  I find this to work fairly well on a large scale.
>
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
