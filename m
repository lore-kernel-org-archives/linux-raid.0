From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 0 of 12] Introduction
Date: Wed, 23 Mar 2005 01:52:54 -0800
Message-ID: <20050323015254.2f2d316c.akpm@osdl.org>
References: <20050323164208.16240.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> 
>  Andrew: Are you happy to keep collecting these as a list of patches
>  (bugs followed by bug-fixes :-), or would it be easier if I merged all
>  the bug fixes into earlier patches and just resent a small number of
>  "add-functionality" patches??

What I'll generally do is to topologically sort the patches.  Work out what
patch each of the new patches fix and then rename the patches to
name-of-the-patch-whcih-is-being-fixed-fix.patch.

So if you had

	foo.patch
	bar.patch

and then sent be "[patch] frob the nozzle"

I'd work out that this new patch is fixing foo.patch and I'd name it
"foo-fix.patch" and the sequence would become:

	foo.patch
	foo-fix.patch
	bar.patch

and then at some time in the future I'll collapse foo-fix.patch,
foo-fix-fix.patch, etc into foo.patch.

Of course it doesn't always work out that simply ;)

In this case it's not clear that a tsort will work out right.  I'll take a
look.

