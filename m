From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Spares and partitioning huge disks
Date: Thu, 13 Jan 2005 13:05:48 +1100
Message-ID: <16869.55164.244476.436097@cse.unsw.edu.au>
References: <200501082025.20463.maarten@ultratux.net>
	<200501082309.j08N9t911087@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Saturday January 8
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'maarten' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 8, bugzilla@watkins-home.com wrote:
> 
> Guy says:
> But, I could tell md which disk I want to spare.  After all, I know which
> disk I am going to fail.  Maybe even an option to mark a disk as "to be
> failed", which would cause it to be spared before it goes off-line.  Then md
> could fail the disk after it has been spared.  Neil, add this to the wish
> list!  :)

Once the "bitmap of potentially dirty blocks" is working, this could
be done in user space (though there would be a small window).

- fail out the chosen drive.
- combine it with the spare in a raid1 with no superblock
- add this raid1 back into the main array.
- md will notice that it has recently been removed and will only
  rebuild those blocks which need to be rebuilt
- raid for the raid1 to fully sync
- fail out the drive you want to remove.

You only have a tiny window where the array is degraded, and it we
were to allow an md array to block all IO requests for a time, you
could make that window irrelevant.

NeilBrown

 
