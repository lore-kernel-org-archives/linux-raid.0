From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Rewrite md raid1 member
Date: Sat, 20 Aug 2016 11:44:32 +0100
Message-ID: <57B83490.2040704@youngman.org.uk>
References: <20160818030451.GA17225@onthe.net.au>
 <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
 <20160818040151.GA21256@onthe.net.au> <57B6F2F5.8090800@youngman.org.uk>
 <20160819124615.GA23247@onthe.net.au>
 <CAJCQCtQs+z6rso4pc7CgRSia4tM5KK=T8ckh93X9HiDHytkcrw@mail.gmail.com>
 <20160820014336.GA30642@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160820014336.GA30642@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>, Chris Murphy <lists@colorremedies.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/08/16 02:43, Chris Dunlop wrote:
> Then again, I guess in the end what I'd really like is to be able to
> flag a particular disk to md for "write repair", and tell md to repair.
> Then md would read data from unflagged disks to write to the flagged
> disk (that could work for parity raids as well as mirrors).

I had that idea. I'm probably better at understanding and documenting
things, hence my interest in the raid wiki, but I'm looking at this
exact thing as a project for my first foray into kernel programming. Is
that wise? :-)

Basically, do a stripe integrity check, and optionally rewrite it? I
don't to what extent linux raid actually implements a lot of interesting
theoretical abilities, and if I can document it, I can then identify
holes and try and fill them. Especially when you're trying to recover a
broken array, the more options you have, the better ...

Unfortunately the raid wiki admin is MIA at the moment, and I really
want to hack that as a learning exercise before I start messing about
with kernel code.

Cheers,
Wol
