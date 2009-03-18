From: david.geib@huskymail.uconn.edu
Subject: Re: Why do I need 4 disks for a raid6?
Date: Tue, 17 Mar 2009 23:41:26 -0400 (EDT)
Message-ID: <62620.69.0.24.162.1237347686.squirrel@huskymailweb.uconn.edu>
References: <87ljr4hsk9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljr4hsk9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Now for the raid6 case. With only 1 data disk and 2 parity disks all 3
> disks should end up with identical data on them. In effect this should
> be a 3 disk raid1, a cpu intensive one. Take an existing raid1 with 2
> or 3 disks, stop the raid, create a new raid6 ovver it with
> --assume-clean, start the raid. After that one can add more disks and
> --grow -n 4/5/6/.. the raid6 to a sensible size. Again without going
> into degraded mode.

If this is the only case where it would be useful, wouldn't it be better
to add an option to mdadm --grow specifying a new raid level, if
different? That way you could take your /dev/md9 raid1 and do:

mdadm --add /dev/md9 /dev/sdc1
mdadm --grow -n 3 /dev/md9 --level=5

or

mdadm --add /dev/md9 /dev/sdc1 /dev/sdd1
mdadm --grow -n 4 /dev/md9 --level=6

or convert a raid5 to raid6 in like fashion, for that matter.

