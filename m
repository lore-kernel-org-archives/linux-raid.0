From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Mon, 7 Mar 2005 22:10:06 -0800
Message-ID: <20050307221006.16806431.akpm@osdl.org>
References: <20050308165021.3745.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050308165021.3745.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> The first two are trivial and should apply equally to 2.6.11
> 
>  The second two fix bugs that were introduced by the recent 
>  bitmap-based-intent-logging patches and so are not relevant
>  to 2.6.11 yet. 

The changelog for the "Fix typo in super_1_sync" patch doesn't actually say
what the patch does.  What are the user-visible consequences of not fixing
this?


Is the bitmap stuff now ready for Linus?
