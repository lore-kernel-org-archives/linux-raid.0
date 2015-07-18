From: Steven Reddie <steven.reddie@gmail.com>
Subject: Reversing parity recalculation on out-of-order RAID 6 array
Date: Sat, 18 Jul 2015 13:16:24 +1000
Message-ID: <CAFcup8FgJqu6q2BoUc7OSEL=iCFf_43wzj7dBuFXYp2R0t2kdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Continuing from the "mdadm --create parameter ordering" thread, I now
want to reverse the effects of recreating the array with the disks
specified in the incorrect order.

Are there existing tools that will help with this?

I've had a quick play around with nbd and I'm confident that I can
write an nbd client that will effectively reorder the underlying disks
and recalculate the parity blocks to present 5 pseudo devices that
look like the original disks. I could then attempt to start an array
via those nbd devices and mount/check the filesystem. This approach
would also allow me to ensure that access to the physical disks is
readonly, and implement copy-on-write if necessary to support this.
I'm kind of hoping that all of this might have already been done, so
any pointers would be appreciated.

[BTW, I also expect that I'll have to mess with metadata and
superblocks, but first need to solve the problem above.]

Thanks,

Steven
