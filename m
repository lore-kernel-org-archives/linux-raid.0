From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: BUG: Data corruption on Raid5 in Linux 2.6.0
Date: Sun, 28 Dec 2003 16:00:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031228160010.B5275@nettis.grimsta>
References: <20031228000008.B2433@nettis.grimsta> <16366.28299.160756.494452@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16366.28299.160756.494452@notabene.cse.unsw.edu.au>; from neilb@cse.unsw.edu.au on Sun, Dec 28, 2003 at 04:47:55PM +1100
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 28, 2003 at 04:47:55PM +1100, Neil Brown wrote:
> On Sunday December 28, daniel.com@wtnord.net wrote:
> > I have a Raid5 system of four 160GB SATA disks. The drives
> > themselves work fine, but when large files (a few hundred
> > megs) are written to the raid disks they get corrupted after
> > a random amount of data.  The kernel is Linus 2.6.0.
> 
> What file system?

I've now tried the same thing on an ext3 filesystem on the
raid5 setup, with the same result.  "cp a b; md5sum a b"
gives different values for b each time.

/Basic

