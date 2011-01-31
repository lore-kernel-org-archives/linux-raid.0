From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: Software RAID and Fakeraid
Date: Mon, 31 Jan 2011 17:12:52 -0500
Message-ID: <20110131221252.GT343@caffeine.csclub.uwaterloo.ca>
References: <4CF55680.5010703@cfl.rr.com> <20101201092508.7023f974@notabene.brown> <4CF81A16.2010606@cfl.rr.com> <20101203123615.6edce071@notabene.brown> <4CF860EB.7010005@cfl.rr.com> <20101209094354.4c6aaa93@notabene.brown> <4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com> <20110131170349.GR343@caffeine.csclub.uwaterloo.ca> <4D470BCF.20508@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D470BCF.20508@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, John Sheu <john.sheu@gmail.com>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 02:21:51PM -0500, Phillip Susi wrote:
> That is why I asked what the partition table should look like.  When
> grub is installed there will be one ( and boot code ), the question is
> whether it should be empty, or have a protective partition that claims
> the entire disk, like EFI does.
> 
> Normally with format 0.9, the raid array starts on sector 0, so the same
> MBR appears both at the start of the first physical disk, and at the
> start of the array.  This is not possible with 1.1 or 1.2, so where do
> they start the array?  I must be at some point further away from sector
> 0, leaving room for a protective MBR on the component disks that would
> be entirely separate from any MBR inside the array.  This leaves room
> for grub to be installed on each component disk, rather than only the
> first.  It also means that it is incompatible with formats 0.9, 1.1, and
> possibly 1.0, depending on whether it includes the first sector in the
> array like 0.9 does.

Well one of them stores the raid info at the end of the device, so that
one offers no help for the bootloader at all.  I think the other stores
it at 4KB in to the device if my memory serves me right.  Not sure if
the first 4KB are left empty for other uses or not.

It seems to me the simplest thing to do is to simply state in
documentation that grub can not be installed on md raid if there is no
partition table in use.  This doesn't mean people can't do it for purely
data oriented drives, but for the drives with the boot laoder there
are limitations.

-- 
Len Sorensen
