From: Neil Brown <neilb@suse.de>
Subject: RE: [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
Date: Sun, 30 Apr 2006 16:00:38 +1000
Message-ID: <17492.21126.316000.952547@cse.unsw.edu.au>
References: <17492.14677.389207.321221@cse.unsw.edu.au>
	<200604300533.k3U5XvB01774@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Sunday April 30
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Molle Bestefich' <molle.bestefich@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 30, bugzilla@watkins-home.com wrote:
> 
> What if a disk is hot added while the filesystem is mounted.  And the new
> disk does not support barriers but the old disks do?  Or you have a mix?

When a disk is added, md will write the superblock and determine if
barriers are supported or not at that time.
On discovering that barriers are not support, md will flag the whole
array as not supporting barriers and will start rejecting barrier
requests.

Filesystems that I have looked at are written to cope with barriers
stopping working.  The first time they get a failure, they turn off
their own "use barriers" flag and retry the request in a more
traditional way.

> 
> If the new disk can't be handled correctly, maybe md should refuse to add
> it.

That isn't necessary.

NeilBrown
