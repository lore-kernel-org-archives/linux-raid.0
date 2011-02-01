From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: Software RAID and Fakeraid
Date: Tue, 1 Feb 2011 11:26:42 -0500
Message-ID: <20110201162642.GU343@caffeine.csclub.uwaterloo.ca>
References: <4CF81A16.2010606@cfl.rr.com> <20101203123615.6edce071@notabene.brown> <4CF860EB.7010005@cfl.rr.com> <20101209094354.4c6aaa93@notabene.brown> <4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com> <20110131170349.GR343@caffeine.csclub.uwaterloo.ca> <4D470BCF.20508@cfl.rr.com> <20110131221252.GT343@caffeine.csclub.uwaterloo.ca> <4D47627A.1080509@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D47627A.1080509@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, The development of GNU GRUB <grub-devel@gnu.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, John Sheu <john.sheu@gmail.com>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 08:31:38PM -0500, Phillip Susi wrote:
> What do you mean help?

If the raid stores the raid info at the end, then the data starts at
sector 0.  So no space for a bootloader at all.

> It is left empty afaik, which is the whole point of shifting it over to 4kb.

Certainly makes sense.  Now is 4K enough for a boot loader?  Not sure.

> Obviously doing nothing is the simplest thing one can do.  Instead I  
> would like to do something and end up with a better, more functional  
> system.  Hence my suggestion on WHAT to do and the existence of this  
> entire thread.

I personally consider soft raid on raw devices so convluted that I
have never done it.  I would rather have something I know works with my
bootloader and other tools, than gain that extra 1MB (at most) that not
having partitions gives.  Also given many PCs won't boot from a drive
without a partition table, it isn't even an option then.

Really I think it comes down to only being able to handle the case
where there is a 4K gap, if you can fit grub in there in a format that
a system would be able to boot reading just sector 0 of the device.
The raid info at the start and raid info at the end both prevent you
from having any boot code in sector 0 so can't be supported at all.

-- 
Len Sorensen
