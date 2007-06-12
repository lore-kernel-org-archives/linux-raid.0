From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: raid5: coding style cleanup / refactor
Date: Tue, 12 Jun 2007 14:32:42 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Unfortunately these cleanups get into a huge fight with your very own
> git-md-accel.patch:
> 
Yes, you missed the note that said:

	Note, I have not rebased git-md-accel yet.  While that is
happening I
	wanted to have this patch out for review.

> I assume that you're prepared to repair all that damage to your tree,
but
> it seems a bit masochistic?

It's either this or have an inconsistent coding style throughout
raid5.c.  I figure it is worth it to have reduced code duplication
between raid5 and raid6, and it makes it easier to add new cache
features going forward.  I have a few more cleanups to add for a rev2 of
this patch, but I will hold that off until the rebase is done.

Dan
