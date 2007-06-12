From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid5: coding style cleanup / refactor
Date: Tue, 12 Jun 2007 15:09:03 -0700
Message-ID: <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I assume that you're prepared to repair all that damage to your tree, but
> > it seems a bit masochistic?
>
> It's either this or have an inconsistent coding style throughout
> raid5.c.  I figure it is worth it to have reduced code duplication
> between raid5 and raid6, and it makes it easier to add new cache
> features going forward.  I have a few more cleanups to add for a rev2 of
> this patch, but I will hold that off until the rebase is done.
>

In other words, it seemed like a good idea at the time, but I am open
to suggestions.
