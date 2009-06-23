From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O
	sizes
Date: Tue, 23 Jun 2009 17:44:46 -0400
Message-ID: <170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1ws73turf.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, snitzer@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Tue, Jun 23, 2009 at 12:54 AM, Martin K.
Petersen<martin.petersen@oracle.com> wrote:
>
> Neil,
>
> Looks like this one missed the boat on the first MD pull request.
> Here's an updated patch that applies to Linus' current tree in case you
> are planning a second round...
>
>
> Switch MD over to the new disk_stack_limits() function which checks for
> aligment and adjusts preferred I/O sizes when stacking.
>
> Also indicate preferred I/O sizes where applicable.

Given that Linus has not yet pulled in the DM changes for 2.6.31
(which includes DM's topology support) I'd imagine it shouldn't be a
problem to get this patch in.  In fact it would be a real shame if
this somehow missed 2.6.31 seeing as MD is the only consumer of the
topology infrastructure's disk_stack_limits().

Neil, please push to Linus for 2.6.31, thanks!

Mike
