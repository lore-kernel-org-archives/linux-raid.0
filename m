From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: forcing larger block sizes?
Date: Sat, 26 Mar 2005 12:05:48 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0503261159550.8358-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it's obvious in retrospect, but I was recently surprised to find 
how huge a difference it makes to use larger blocks with raid,
especially raid5.  (a large, aligned r5 write can avoid parity reads,
and thus *flies*!).

so how do you get the filesystem to produce larger IOs?  "large" here
is much larger than the typical FS blocksize.  ideally, you want chunks
of, say, 64K going to each disk, so if you have an 8+1 r5, you'd really
like to see writes of at least 512K.

I was wondering whether perhaps DM could "reblock" a filesystem.

thanks, mark hahn.

