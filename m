From: Drew <drew.kay@gmail.com>
Subject: Re: convert metadata version: possible/wise?
Date: Mon, 15 Oct 2012 12:14:50 -0700
Message-ID: <CACJz6QtmXhsDSwg6GhvRqYggrAx4s89O5o_g1BziLLkS6C9Dow@mail.gmail.com>
References: <vd2uk9xo62.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <vd2uk9xo62.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The default CentOS 6 install media creates md devices with metadata 1.1
> (or, it seems like, 1.0 for /boot).  I was wondering, first off, is
> there any advantage to try to attempt to migrate these to metadata 1.2?
> I suppose that RHEL/CentOS had some reason for making /boot 1.0 (perhaps
> the newer metadata formats can not be booted), so for now let's just
> consider migrating from 1.1 to 1.2.  If there are any advantages, what
> would they be?  And would it generally be a big advantage or a
> relatively minor one?

One thing to keep in mind with the 1.x metadata family is that the
three "versions" merely indicate where the metadata is located, not
that one is newer or better then the others.

1.0 places metadata at the end, 1.1 at the beginning, and 1.2 4K in
from the beginning. The 'correct' sub-version will depend on your
application.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
