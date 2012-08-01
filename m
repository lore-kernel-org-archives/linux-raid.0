From: matt <listy@fastmail.fm>
Subject: OT: silent data corruption reading from hard drives
Date: Wed, 01 Aug 2012 08:02:38 -0400
Message-ID: <50191ADE.10809@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quick intro: Last year I was having problems with an md array
continuously having a mismatch_cnt in the tens of thousands,
inexplicably.  After a week or two of hardware swapping and such, I
narrowed it down to bad reads of the hard drive block devices.  I used
scripts that would repetitively do something like this on all my drives:
      dd if=/dev/sdk1 bs=1024 count=50000000 |md5sum -b
Some devices would intermittently get different results.  I ended up
resolving (?) it by replacing the cheapo (Syba) SATA controller cards
with other cheapo (Rosewill) ones.  I've been fine for about a year
since then.

But now it's just started happening again.  Although this isn't an md
question per se, I'm hoping some of you raid/kernel/storage gurus can
give me some tips on how to trace this in a better way than my haphazard
method last year.  Is there any way to detect these bad reads when they
happen?  (Apparently not?)   What about finding out if the cause is the
motherboard, the controller card, the device driver, or the kernel?
(Besides swapping hardware?)  Can the md layer help out in this regard?
  Are there known bugs or hardware nuances that relate to this?  Is
silent data corruption like this simply to be expected when using cheap
commodity hardware?

Thanks for reading...

matt
