From: dean gaudet <dean@arctic.org>
Subject: Re: Setting write-intent bitmap during array resync/create?
Date: Tue, 10 Oct 2006 22:14:55 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0610102213020.20016@twinlark.arctic.org>
References: <452BF505.9020608@ilm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <452BF505.9020608@ilm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Stair <estair@ilm.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 10 Oct 2006, Eli Stair wrote:

> I gather this isn't currently possible, but I wonder if it's feasible to make
> it so?  This works fine once the array is marked 'clean', and I imagine it's
> simpler to just disallow the bitmap creation until it's in that state.  Would
> it be possible to allow creation of the bitmap by queueing the action until
> the array is done rebuilding?

why don't you add "-b internal" to the mdadm --create command line?  

-dean
