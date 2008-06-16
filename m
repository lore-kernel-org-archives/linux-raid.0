From: Jesse Molina <jmolina@tgen.org>
Subject: Re: Failed RAID5 array grow after reboot interruption; mdadm:
 Failed to restore critical section for reshape, sorry.
Date: Mon, 16 Jun 2008 09:48:26 -0700
Message-ID: <C47BE76A.9030%jmolina@tgen.org>
References: <49481.61.88.57.1.1213610425.squirrel@home.kendrummond.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49481.61.88.57.1.1213610425.squirrel@home.kendrummond.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ken Drummond <ken.drummond@kendrummond.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks.  I'll give the updated mdadm binary a try.  It certainly looks
plausible that this was a recently fixed mdadm bug.

For the record, I think you typoed this below.  You meant to say v2.6.4,
rather than v2.4.4.  My current version was v2.6.3.  The current mdadm
version appears to be v2.6.4, and Debian currently has a -2 release.

My system is Debian unstable, just as FYI.  It's been since January 2008
since v2.6.4-1 was released, so I guess I've not updated this package since
then.

Here is the changelog for mdadm;

http://www.cse.unsw.edu.au/~neilb/source/mdadm/ChangeLog

Specifically;

"Fix restarting of a 'reshape' if it was stopped in the middle."

That sounds like my problem.

I will try this here in an hour or two and see what happens...



On 6/16/08 3:00 AM, "Ken Drummond" <ken.drummond@kendrummond.com> wrote:

> There was an announcement on this
> list for v2.4.4 which included fixes to restarting an interrupted grow.

-- 
# Jesse Molina
# The Translational Genomics Research Institute
# http://www.tgen.org
# Mail = jmolina@tgen.org
# Desk = 1.602.343.8459
# Cell = 1.602.323.7608


