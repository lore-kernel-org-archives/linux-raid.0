From: Neil Brown <neilb@suse.de>
Subject: Re: [GIT PATCH 0/2] stripe-queue for 2.6.23 consideration
Date: Mon, 23 Jul 2007 17:10:02 +1000
Message-ID: <18084.21578.171810.48265@notabene.brown>
References: <20070722094115.18906.64495.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Sunday July 22
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 22, dan.j.williams@intel.com wrote:
> Andrew, Neil,
> 
> The stripe-queue patches are showing solid performance improvement.
> 
> 	git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus
> 
>  drivers/md/raid5.c         | 1484 ++++++++++++++++++++++++++++++++------------
>  include/linux/raid/raid5.h |   87 +++-
>  2 files changed, 1164 insertions(+), 407 deletions(-)
> 
> Dan Williams (2):
>       raid5: add the stripe_queue object for tracking raid io requests (take2)
>       raid5: use stripe_queues to prioritize the "most deserving" requests (take4)
> 
> I initially considered them 2.6.24 material but after fixing the sync+io
> data corruption regression, fixing the large 'stripe_cache_size' values
> performance regression, and seeing how well it performed on my IA
> platform I would like them to be considered for 2.6.23.  That being said
> I have not yet tested expand operations or raid6.
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I think we really shouldn't aim for 2.6.23 at this stage.  The merge
window is shut, and this is a little more that a bug fix.  It's sounds
great though.  I'd really like to hear more success reports, and will
do my own review a testing either this week or next.

Certainly good for -mm.

NeilBrown
