From: Neil Brown <neilb@suse.de>
Subject: Re: Is it possible to recover data after resync?
Date: Thu, 20 Jul 2006 11:08:27 +1000
Message-ID: <17598.55179.66969.564751@cse.unsw.edu.au>
References: <20060719184048.96988.qmail@web50204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Davis on Wednesday July 19
Sender: linux-raid-owner@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 19, alex14641@yahoo.com wrote:
> Situation:
> 
> I accidentally killed the power to my 5-disk RAID 5 array. I then powered
> it back up and rebooted the system. After reboot, however, I got the follow-
> ing error when trying to assemble the array:
> 
> mdadm -A -amd /dev/md0 /dev/sd[a-e]
> mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
> 
> I had read somewhere that it's possible to recover an array using the -C
> option to mdadm. Unfortunately, I didn't specify 'missing', so instead of
> recovering, it's resyncing. 

--assemble --force is worth try first and is much safer.

> 
> Is there any way to recover the original data?

Well, if you got all the right devices in the right order, then your
data should be fine.  If not, I hope you have good backups, because
they are your only hope.

NeilBrown
