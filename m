From: Keld Simonsen <keld@keldix.com>
Subject: activating spares
Date: Wed, 10 Mar 2010 08:43:43 +0100
Message-ID: <20100310074343.GA26813@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I made a raid10,f2 arrray (actually 2 arrays) with only one
active disk, one missing. This was after 2 disks were found faulty,
and I then copied the data from my faulty raid to the new  raid, and
installed my other new 2 TB disk. I added the new disk with
     mdadm /dev/md9 --add /dev/sdg1
and it was then listed as a spare. I wanted to activate it, and thought
that --add ing it would automatically start resyncing, but no...
I then tried to force resyncing by 
     mdadm -A /dev/md9 --update resync
but it did not work either. Now I am lost. How do I activate the spare?

kernel 2.6.12 mdadm v1.12.0

best regards
keld
