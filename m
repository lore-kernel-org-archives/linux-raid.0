From: "NeilBrown" <neilb@suse.de>
Subject: Re: Subject: [001/001 ] raid0 remove hashing, variable chunk size
Date: Thu, 14 May 2009 07:04:11 +1000 (EST)
Message-ID: <691b51234567a1fcea495b655f3275de.squirrel@neil.brown.name>
References: <1242237805.8753.6.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242237805.8753.6.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@013.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 14, 2009 4:03 am, raz ben yehuda wrote:
> 1. Beautify raid0 code
> 2. Remove hashing
> 3. Chunk size of 4K*n instead of 4K*2^n ( must apply a patch to mdadm ).
> patch was tested with backward compatibility to 2.6.18. i did not test
> 32bit, i do have
> a 32bit compiler for 2.6.30-rc2.
>  md.c    |   24 ++-
>  raid0.c |  428
> ++++++++++++++++++++++++++++++----------------------------------
>  raid0.h |    3
>  3 files changed, 221 insertions(+), 234 deletions(-)

That is a very small description for a very big patch.

As it does 3 different things, can you make it into three different
patches?  That tends to make it a lot easier to review.

> Signed-of-By : Neil Brown neilb@suse.de

You are meant to put your own email address here, not mine.

NeilBrown

