From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [lvm-devel] [PATCH] lvm2 support for detecting v1.x MD superblocks
Date: Tue, 23 Oct 2007 22:34:40 -0400
Message-ID: <170fa0d20710231934k6e33c79arae856783f0420bfc@mail.gmail.com>
References: <170fa0d20710230832v3313d38fmc646d89c1b990252@mail.gmail.com>
	 <20071024004435.GD10006@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071024004435.GD10006@agk.fab.redhat.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LVM2 development <lvm-devel@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/23/07, Alasdair G Kergon <agk@redhat.com> wrote:
> On Tue, Oct 23, 2007 at 11:32:56AM -0400, Mike Snitzer wrote:
> > I've tested the attached patch to work on MDs with v0.90.0, v1.0,
> > v1.1, and v1.2 superblocks.
>
> I'll apply this, thanks, but need to add comments (or reference) to explain
> what the hard-coded numbers are:
>
>         sb_offset = (size - 8 * 2) & ~(4 * 2 - 1);
> etc.

All values are in terms of sectors; so that is where the * 2 is coming
from.  The v1.0 case follows the same model as the MD_NEW_SIZE_SECTORS
which is used for v0.90.0.  The difference is that the v1.0 superblock
is found "at least 8K, but less than 12K, from the end of the device".

The same switch statement is used in mdadm and is accompanied with the
following comment:

        /*
         * Calculate the position of the superblock.
         * It is always aligned to a 4K boundary and
         * depending on minor_version, it can be:
         * 0: At least 8K, but less than 12K, from end of device
         * 1: At start of device
         * 2: 4K from start of device.
         */

Would it be sufficient to add that comment block above
v1_sb_offset()'s switch statement?

thanks,
Mike
