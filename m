From: sanktnelson 1 <sanktnelson@googlemail.com>
Subject: Re: help please - recovering from failed RAID5 rebuild
Date: Wed, 13 Apr 2011 18:45:49 +0200
Message-ID: <BANLkTimwj=J+6VYnmeMA=AFPq9bUc2dJNA@mail.gmail.com>
References: <BANLkTinAmEgsbOx4k5yxCdHmM0GBWbXdBA@mail.gmail.com>
	<20110408220130.4830852d@notabene.brown>
	<BANLkTimSh8f8cVihRxbKgKZq4zFv6VUmVQ@mail.gmail.com>
	<20110409212930.6f4ffb28@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110409212930.6f4ffb28@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

thanks a lot, the array is rebuilt and redundant again, apparently
with no loss of data (at least all fscks ran without complaints).

It took me a while to get to this point, since the dd_rescue randomly
failed after an hour or two, so I didn't get to try more than once per
night. That seems to be fixed now with a new SATA cable.

I just wanted to quickly write down here what the original cause of
the problem was, in case someone ever googles this conversation:

after

mdadm -Af /dev/md0 /dev/sd[bdef]1
fsck -nf /dev/md0

I would get the message that /dev/md0 was busy, even though according
to mount it was not mounted anywhere. Trying to mount it would report
it as already mounted, but the data was not visible at its usual
mountpoint. This was indeed the same symptom I had had in the first
place after trying with --re-add and --run.

It turns out ubuntu does something odd with mounts that are mentioned
in /etc/fstab but are not available at bootime. I did not understand
what this actually is, but as a result the device is "in use" even
though the data is not visible at the mount point. After I temporarily
removed /dev/md0 from /etc/fstab and rebooted I was able to follow
your advice to the letter without any more problems, and I strongly
suspect my original approach would have worked as well.

Again, thank you so much for your help!

Cheers,
Felix
