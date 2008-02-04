From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
Date: Mon, 04 Feb 2008 16:52:10 +0300
Message-ID: <47A7188A.4070005@msgid.tls.msk.ru>
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A6EFCF.9080906@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
[]
> If I'm reading the man pages, Wikis, READMEs and mailing lists correctly
> --  not necessarily the case -- the ext3 file system uses the equivalent
> of data=journal as a default.

ext3 defaults to data=ordered, not data=journal.  ext2 doesn't have
journal at all.

> The question then becomes what data scheme to use with reiserfs on the

I'd say don't use reiserfs in the first place ;)

> Another way to phrase this: unless you're running data-center grade
> hardware and have absolute confidence in your UPS, you should use
> data=journal for reiserfs and perhaps avoid XFS entirely.

By the way, even if you do have a good UPS, there should be some
control program for it, to properly shut down your system when
UPS loses the AC power.  So far, I've seen no such programs...

/mjt
