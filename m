From: Brad Campbell <brad@wasp.net.au>
Subject: Raidtools-1.00.3
Date: Wed, 05 May 2004 16:49:28 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4098E2D8.7070007@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

 From what I gather, the idea is to let the old raidtools just die and move over to mdadm for raid 
maintenance?

I'm just wondering as raidreconf relies pretty heavily at the moment on some of the raidtools 
infrastructure and I'm wondering what to do long term.
I have added raid-6 support to raidtools and updated it to work with kernel 2.6 and LBD, but if the 
long term plan is to let it bitrot then perhaps I'd be better looking at migrating raidreconf to 
some other framework and try to make it use mdadm for the low level stuff.

Ideas or suggestions?

As an aside, I successfully reconfigured a 7 disk 1.4TB raid-5 to a 10 disk 2.1TB raid 5 last week. 
It took a little over 21 hours to do the reconf and 9 hours to do a resync, but it all came up great.

I did have a full backup of the entire array, so of course Murphy took a hike. I'm sure had I not 
had a backup it would have gone pear shaped :p)


Blessed are the pessimists, for they make the backups.

Regards,
Brad
