From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: BUG: Data corruption on Raid5 in Linux 2.6.0
Date: Mon, 29 Dec 2003 13:19:12 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031229131912.C9872@nettis.grimsta>
References: <20031228000008.B2433@nettis.grimsta> <16366.28299.160756.494452@notabene.cse.unsw.edu.au> <20031228091722.B4400@nettis.grimsta> <20031229000227.GC1882@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031229000227.GC1882@matchmail.com>; from mfedyk@matchmail.com on Sun, Dec 28, 2003 at 04:02:27PM -0800
To: Daniel Brahneborg <daniel.com@wtnord.net>, Neil Brown <neilb@cse.unsw.edu.au>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 28, 2003 at 04:02:27PM -0800, Mike Fedyk wrote:
> On Sun, Dec 28, 2003 at 09:17:22AM +0100, Daniel Brahneborg wrote:
> > I get the same problem without it, just a few more "dma_intr:
> > DriveReady SeekComplete Error" in the syslog.
> 
> You are having hard drive problems.

Perhaps... But it doesn't explain my raid5 problems.

>  o check your cables
>  o check your drives with smartmontools

I've run the "short" test on all four disks now, and got no
errors.

I've also done my "cp /tmp/a b ; md5sum /tmp/a b" where /tmp/a
is a 500Mb file with random data on filesystems on the individual
partitions on the four drives.  That works fine every time.
Doing the same on the raid5 device on the same drives fails every
time if the file is large enough (more than say 100 MB).  I also
don't get any kind of warnings in the syslog when accessing the
raid5 device.

Just to make sure, I used the same 5GB partitions for both tests,
and when a partition is used by itself it works fine. When the
same partition is used in a raid5 setup, I get corrupted files.
I've tested all four drives.

/Basic

