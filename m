From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: [Bugme-new] [Bug 4211] New: md configuration destroys disk GPT label
Date: Tue, 15 Feb 2005 11:36:12 +1100
Message-ID: <16913.17404.799815.38675@cse.unsw.edu.au>
References: <20050214101705.56507c64.akpm@osdl.org>
	<200502141910.j1EJA6911593@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Guy on Monday February 14
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, linux-raid@vger.kernel.org, aspanke@gmail.com
List-Id: linux-raid.ids

On Monday February 14, bugzilla@watkins-home.com wrote:
> Maybe I am confused, but if you use the whole disk, I would expect the whole
> disk could be over-written!  What am I missing?

I second that.

Once you do anything to a whole disk, whether make an md array out of
it, or mkfs it or anything else, you can kiss any partitioning
goodbye.

Maybe what you want to do it make an md array and then partition
that.
In 2.6 you can do that directly.  In 2.4 you would need to use LVM to
partition the array.

NeilBrown
