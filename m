From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Can't mount after mkfs -b 8192
Date: Fri, 4 Jun 2004 15:22:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16576.1816.259780.986410@cse.unsw.edu.au>
References: <40BFA6DD.6000904@dgreaves.com>
	<200406040127.i541RB316590@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Thursday June 3
To: Guy <bugzilla@watkins-home.com>
Cc: 'David Greaves' <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 3, bugzilla@watkins-home.com wrote:
> I am sure a patch would be considered!  But what do I know?
> I do agree that the state should be something other than "clean, no-errors"!
> Maybe:
> 	"clean, no-errors, degraded"
> Or
> 	"clean, no-errors, degraded, recovering"

Good suggestion.  It will be in the next release of mdadm (due out
shortly).
The "no-errors" will be gone though.  It doesn't mean anything.

> 
> Not even sure it's clean if a disk is missing.  The parity can't be up to
> date!

Well.... the parity had better be up-to-date, or you have data
corruption.
When an array is running, the kernel will maintain sufficient state
that it always knows what should be where, but the data actually on
disk may be "clean" or not.
If you crash with a non-clean array with a failed disk, then you loose
data (and need --assemble --force to restart the array).

> Also seems like a missing disk would be an error!

No, a degradation.  2 missing  disks in a raid5 would be a failure.
I don't report that yet.

NeilBrown
