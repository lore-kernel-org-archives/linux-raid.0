From: maarten van den Berg <maarten@vbvb.nl>
Subject: two-disk-failure question
Date: Fri, 17 Oct 2003 23:15:56 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310172315.56815.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi List,

I've a problem which unfortunately hit me yesterday.  I have the dreaded 
"two-disk-failure" on a 6 disk raid5 volume.  I read the fine howto chapter 
6.1 at unthought.net and before I start (with somewhat shaking hands... ;-| ) 
I need some clearing up of an issue / question...

Quote:

"To get this to work, you'll need to have an up to date /etc/raidtab - if it 
doesn't EXACTLY match devices and ordering of the original disks this will 
not work as expected, but will most likely completely obliterate whatever 
data you used to have on your disks."

Now I can't be completely absolutely sure I did not -at some point- re-order 
cables and such. So my obvious question is:  Is this step (mkraid --force 
with one of the offline disks defined as failed-disk) destructive, or could I 
(theoretically) experiment endlessly with the order in which the disks are 
defined in /etc/raidtab before I decide to mount it read-write and raidhotadd 
a fresh disk ?

Second question, If one is sufficiently adept at looking at raw disk 
structures (notably the suberblocks), can a human find out which disk is 
which, ie. in which order they DO belong ?

Thanks for any and all help regarding this. I have 400 Gigs at stake here...
:-(

Maarten 

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
