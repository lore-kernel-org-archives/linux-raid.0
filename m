Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BBAC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 29 Dec 2021 04:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbhL2EhR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Dec 2021 23:37:17 -0500
Received: from dione.uberspace.de ([185.26.156.222]:51678 "EHLO
        dione.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhL2EhR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Dec 2021 23:37:17 -0500
Received: (qmail 13029 invoked by uid 989); 29 Dec 2021 04:37:15 -0000
Authentication-Results: dione.uberspace.de;
        auth=pass (plain)
Date:   Wed, 29 Dec 2021 05:37:14 +0100
From:   Andreas Klauer <Andreas.Klauer@metamorpher.de>
To:     Tony Bush <thecompguru@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Need help Recover raid5 array
Message-ID: <Ycvl+joeW+b9CpNj@metamorpher.de>
References: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
 <Yb8ebs7lhEHHTqif@metamorpher.de>
 <CAA9kLn1JwRLWpOd-kRnLj2YqQhkRM_R_LFisA9_acxHdFJpFVg@mail.gmail.com>
 <YcV6tUwlKd+tLd78@metamorpher.de>
 <CAA9kLn3AYkoa5ybqoxoVRg1umhCbAwsshGNDPtV05tU7K-ZCAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9kLn3AYkoa5ybqoxoVRg1umhCbAwsshGNDPtV05tU7K-ZCAQ@mail.gmail.com>
X-Rspamd-Bar: /
X-Rspamd-Report: MIME_GOOD(-0.1)
X-Rspamd-Score: -0.1
Received: from unknown (HELO unkown) (::1)
        by dione.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 29 Dec 2021 05:37:14 +0100
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 28, 2021 at 06:56:35PM -0500, Tony Bush wrote:
> I then mounted the drive as my user, tested multiple large files and
> when i was done crying i unmounted

:-)

> My next task is creating a new raid that is inside of partitions.

Now that you know how to create overlays and verified the data 
is still there... if you want partitions you can do the whole 
thing one more time.

Your data offset is 257024 sectors so you can take 2048 sectors 
off that to create a partition at 1 MiB offset.

Since GPT has a partition table backup at end of drive, you might 
also have to shrink the filesystem on the RAID just a little to 
make room for that.

Test it all on overlays until you make it work...

> Need to do this with 2 new drives, transfer 10TB, then shrink and
> remove a drive to add to new raid, transfer and repeat.

> Let me know if this is a bad idea please.

Growing is way more common than the other way around.
Things can go mysteriously wrong when shrinking stuff. 

As an alternative to the overlay method mentioned above, 
if you do not mind re-syncing, you could also mdadm --replace 
your full disk members with partitioned members.

It will complain about the device "not large enough to join array" 
so you still have to shrink the filesystem just a little and shrink 
the RAID itself accordingly until the device is not too small anymore.

The main issue is that mdadm's --max-size and --size options can 
be difficult to deal with. So things can go wrong here, too.

Test it on a separate array (loop devices) first...

# mdadm --grow /dev/md100 --array-size=max
(no output, check dmesg or /proc/mdstat for size)
      25132032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
# blockdev --getsize64 /dev/md100
25735200768

### shrink filesystem on /dev/md100 to 25100000K

# mdadm --grow /dev/md100 --array-size=25100000K

### double check that filesystem is still OK here

# mdadm /dev/md100 --add /dev/loop5
mdadm: /dev/loop5 not large enough to join array
# mdadm --grow /dev/md100 --size=max
mdadm: component size of /dev/md100 unchanged at 8377344K
# mdadm --grow /dev/md100 --size=8377343K
mdadm: component size of /dev/md100 has been set to 8376832K
# mdadm /dev/md100 --add /dev/loop5
mdadm: /dev/loop5 not large enough to join array
# mdadm --grow /dev/md100 --size=8376831K
mdadm: component size of /dev/md100 has been set to 8376320K
# mdadm /dev/md100 --add /dev/loop5
mdadm: added /dev/loop5
# mdadm /dev/md100 --replace /dev/loop3

# cat /proc/mdstat
md100 : active raid5 loop5[6](R) loop4[5] loop3[4] loop2[2] loop1[1] loop0[0](F)
      25100000 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      [=========>...........]  recovery = 45.4% (3806592/8376320) finish=0.3min speed=200346K/sec

# mdadm --grow /dev/md100 --size=max
# mdadm --grow /dev/md100 --array-size=max
# resize2fs /dev/md100

Something like this, might maybe work if you had to do it without overlays.

Not sure if there is a simpler way right now.

Regards
Andreas Klauer
