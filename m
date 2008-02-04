From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 12:27:29 +0300
Message-ID: <47A6DA81.3030008@msgid.tls.msk.ru>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A62A17.70101@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
[]
> But that's *exactly* what I have -- well, 5GB -- and which failed. I've
> modified /etc/fstab system to use data=journal (even on root, which I
> thought wasn't supposed to work without a grub option!) and I can
> power-cycle the system and bring it up reliably afterwards.

Note also that data=journal effectively doubles the write time.
It's a bit faster for small writes (because all writes are first
done into the journal, i.e. into the same place, so no seeking
is needed), but for larger writes, the journal will become full
and data found in it needs to be written to proper place, to free
space for new data.  Here, if you'll continue writing, you will
have more than 2x speed degradation, because of a) double writes,
and b) more seeking.

/mjt
