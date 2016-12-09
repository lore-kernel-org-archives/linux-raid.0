From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] md: Combine two kmalloc() calls into one in sb_equal()
Date: Fri, 09 Dec 2016 13:57:57 -0800
Message-ID: <1481320677.5946.44.camel@perches.com>
References: <f4df733d-8e06-8ba1-c4c3-800d8c5615ba@users.sourceforge.net>
         <1481310314.5946.40.camel@perches.com>
         <20161209213030.GC1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161209213030.GC1555@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2016-12-09 at 21:30 +0000, Al Viro wrote:
> On Fri, Dec 09, 2016 at 11:05:14AM -0800, Joe Perches wrote:
> > On Fri, 2016-12-09 at 19:30 +0100, SF Markus Elfring wrote:
> > > From: Markus Elfring <elfring@users.sourceforge.net>
> > > Date: Fri, 9 Dec 2016 19:09:13 +0100
> > > 
> > > The function "kmalloc" was called in one case by the function "sb_equal"
> > > without checking immediately if it failed.
> > > This issue was detected by using the Coccinelle software.
> > > 
> > > Perform the desired memory allocation (and release at the end)
> > > by a single function call instead.
> > > 
> > > Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
> > 
> > Making a change does not mean fixes.
> > 
> > There's nothing particularly _wrong_ with the code as-is.
> > 
> > 2 kmemdup calls might make the code more obvious.
> > 
> > There's a small optimization possible in that only the
> > first MB_SB_GENERIC_CONSTANT_WORDS of the struct are
> > actually compared.  Alloc and copy of both entire structs
> > is inefficient and unnecessary.
> > 
> > Perhaps something like the below would be marginally
> > better/faster, but the whole thing is dubious.
> > 
> > static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
> > {
> > 	int ret;
> > 	void *tmp1, *tmp2;
> > 
> > 	tmp1 = kmemdup(sb1, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32), GFP_KERNEL);
> > 	tmp2 = kmemdup(sb2, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32), GFP_KERNEL);
> > 
> > 	if (!tmp1 || !tmp2) {
> > 		ret = 0;
> > 		goto out;
> > 	}
> > 
> > 	/*
> > 	 * nr_disks is not constant
> > 	 */
> > 	((mdp_super_t *)tmp1)->nr_disks = 0;
> > 	((mdp_super_t *)tmp2)->nr_disks = 0;
> > 
> > 	ret = memcmp(tmp1, tmp2, MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32)) == 0;
> > 
> > out:
> > 	kfree(tmp1);
> > 	kfree(tmp2);
> > 	return ret;
> > }
> 
> May I politely inquire if either of you has actually bothered to read the
> code and figure out what it does?  This is grotesque...
> 
> For really slow: we have two objects.  We want to check if anything in the
> 128-byte chunks in their beginnings other than one 32bit field happens to be
> different.  For that we
> 	* allocate two 128-byte pieces of memory
> 	* *copy* our objects into those
> 	* forcibly zero the field in question in both of those copies
> 	* compare the fuckers
> 	* free them
> 
> And you two are discussing whether it's better to combine allocations of those
> copies into a single 256-byte allocation?  Really?

No.  May I suggest you read my suggestion?
At no point did I suggest a single allocation.

I think the single allocation is silly and just
makes the code harder to read.

>   _IF_ it is a hot path,
> the obvious optimization would be to avoid copying that crap in the first
> place - simply by
> 	return memcmp(sb1, sb2, offsetof(mdp_super_t, nr_disks)) ||
> 	       memcmp(&sb1->nr_disks + 1, &sb2->nr_disks + 1,
> 			MD_SB_GENERIC_CONSTANT_WORDS * sizeof(__u32) -
> 			offsetof(mdp_super_t, nr_disks) - 4);

That's all true, but Markus has enough trouble reading simple
code without trying to explain to him what offsetof does.

btw:  the "- 4" should be " - sizeof(__u32)" just for consistency
with the line above it.

> If it is _not_ a hot path, why bother with it at all?

exactly.
