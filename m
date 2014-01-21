From: Marc MERLIN <marc@merlins.org>
Subject: Very long raid5 init/rebuild times
Date: Mon, 20 Jan 2014 23:35:40 -0800
Message-ID: <20140121073540.GF10140@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

I'm setting up a new array with 5 4TB drives for which I'll use dmcrypt.

Question #1:
Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
(raid5 first, and then dmcrypt)
I used:
cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/sd[mnopq]1


Question #2:
In order to copy data from a working system, I connected the drives via an external
enclosure which uses a SATA PMP. As a result, things are slow:

md5 : active raid5 dm-7[5] dm-6[3] dm-5[2] dm-4[1] dm-2[0]
      15627526144 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
      [>....................]  recovery =  0.9% (35709052/3906881536) finish=3406.6min speed=18939K/sec
      bitmap: 0/30 pages [0KB], 65536KB chunk

2.5 days for an init or rebuild is going to be painful. 
I already checked that I'm not CPU/dmcrpyt pegged.

I read Neil's message why init is still required:
http://marc.info/?l=linux-raid&m=112044009718483&w=2
even if somehow on brand new blank drives full of 0s I'm thinking this could be faster
by just assuming the array is clean (all 0s give a parity of 0).
Is it really unsafe to do so? (actually if you do this on top of dmcrypt
like I did here, I won't get 0s, so that way around, it's unfortunately
necessary).

I suppose that 1 day-ish rebuild times are kind of a given with 4TB drives anyway?


Question #3:
Since I'm going to put btrfs on top, I'm almost tempted to skip the md raid5
layer and just use the native support, but the raid code in btrfs still
seems a bit younger than I'm comfortable with.
Is anyone using it and has done disk failures, replaces, and all?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
