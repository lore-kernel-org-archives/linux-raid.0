From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Mon, 04 Aug 2003 13:46:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2E9C07.81A10C54@SteelEye.com>
References: <3F2D1FAC.9030905@shaolinmicro.com> <1059929757.6751.60.camel@ralph.plexio.private> <3F2E8B0E.6060007@shaolinmicro.com> <20030804170620.GA3159@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: David Chow <davidchow@shaolinmicro.com>
Cc: Ross Vandegrift <ross@willow.seitz.com>, Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ross Vandegrift wrote:
 
> I wonder - have you accidently created a mirror and then added a
> hot-spare?  I've run into this problem before when switching to mdadm,
> and it confused me pretty well.

Hmm, good thought, but I don't think that would be it, since his mdstat
is showing 2 raid-disks for each array.

David, could you send the rest of your log from the time you create the
array until after the hot add? I'm wondering what's in the log when the
hot add is done. Are there errors?

Also, would it be possible to run "mdadm --examine /dev/sd[ab]3" and/or
run this:

perl -e '$io_num = 0x0913; open (FD, "/dev/md2") or die "open: $!";
ioctl(FD, $io_num, $null) or die "ioctl: $!";'

and send the log output, so we can see what's in the superblocks?

--
Paul
