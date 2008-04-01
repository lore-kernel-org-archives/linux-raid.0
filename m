From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: raid1 will force fullsync when it seemingly should not
Date: Tue, 1 Apr 2008 03:45:11 -0400
Message-ID: <170fa0d20804010045r47a82ff8q37daed86e998b430@mail.gmail.com>
References: <170fa0d20803312341u6ea23e39r93030a7381c229b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20803312341u6ea23e39r93030a7381c229b9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 1, 2008 at 2:41 AM, Mike Snitzer <snitzer@gmail.com> wrote:
> Hi Neil,
>
>  I've been looking into another scenario where a raid1 with members
>  that have an internal bitmap are performing what seems to be an
>  unnecessary 'fullsync' on re-add.  I'm using 2.6.22.19 +
>  918f02383fb9ff5dba29709f3199189eeac55021
>
>  To be clear this isn't a pathological bug with the generic sequence
>  I'm about to describe

OK, so I'm taking that back... it does seem to be pathological.
Albeit obscure.  It now seems clear that this is a corner case
associated with stopping the array just after having a member (with an
internal bitmap) go degraded.

If I do the same sequence, but do _not_ stop the array, the faulty
member can be hot-removed and hot-added without:
1) treating the faulty member as "non-fresh"
2) treating the "md's bitmap's events_cleared > faulty member's
events" as a negative that requires 'fullsync'

To be clear, the first super_90_validate() negative check (1 above) is
skipped because mddev->pers != NULL... BUT for the other negative
check (2 above) the array did have the md's events_cleared=30497 and
the faulty's events=30496.  But given that I didn't stop the array
this seemed to be a none-issue for MD.  Maybe its not even calling
super_validate() for the re-added faulty member if the array hasn't
been shutdown? (I need sleep so me answering this will have to
wait)...

Or could it be that MD has additional transient state, when it hasn't
been shutdown, that enables super_90_validate() et al to view the
persistent sb and internal bitmap's data differently?

Mike
