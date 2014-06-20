From: Matthias Eble <psychotrahe@gmail.com>
Subject: Re: md kernel thread hung in raid1_add_disk
Date: Fri, 20 Jun 2014 22:29:28 +0200
Message-ID: <CAKbOo_JeT9mRgnrL-+xciWqaupgMnwqw4OhCo7p38P7yLLqSTg@mail.gmail.com>
References: <CAKbOo_+414WYYfwEqRnhgdxp-GJGq0_koVaN89RvEydHZ3QZ=w@mail.gmail.com>
	<20140611094516.6a310ba8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140611094516.6a310ba8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, hi list,

>>    * OS is Rhel6, kernel is 2.6.32-358.6.2.el6.x86_64
>
> Presumably you are running such an ancient kernel because you have a support
> contract with Redhat?  In that case it would be best to ask them.
>
> If you have problems with a recent kernel this is certainly the best place to
> ask...

understood. Still I'd like to post our current findings, if someone
with the same problem
will ever find this thread in the list archives:

* The Bug is very likely fixed by vanilla's
  e2d599252 md/raid1,raid10: use freeze_array in place of
raise_barrier in various places
* The commit was applied to RHEL's 2.6.32-407 kernel (RHEL 6.5; Fri Aug  2 2013)
* according to the commit message, the deadlock problem was
"particularly noticeable
  by commits 050b66152f87c7 (raid10) and 6b740b8d79252f13 (raid1)"
   * these were applied with RHEL's 2.6.32-300 (Fri Aug 17 2012)

Since we ran -358 and the call traces directed us exactly to the lines
of code that were
fixed by the freeze_array commit, we're quite confident that the
update fixed our issue.

Matthias
