From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 0/3] md bitmap-based asynchronous writes
Date: Mon, 21 Mar 2005 15:21:43 +1100
Message-ID: <16958.19415.701152.371199@cse.unsw.edu.au>
References: <422F7621.8090602@steeleye.com>
	<16949.5768.392061.95882@cse.unsw.edu.au>
	<4239EDCA.4030502@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Paul Clements on Thursday March 17
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 17, paul.clements@steeleye.com wrote:
> These three patches provide the ability to perform asynchronous writes 
> with raid1. The asynchronous write capability is primarily useful when 
> raid1 is employed in network replication (i.e., with one or more of the 
> disks located on a remote system). It allows us to acknowledge writes 
> before they reach the remote system, thus making much more efficient use 
> of the network.

Thanks for these.

However I would like to leave them until I'm completely happy with the
bitmap resync, including
  - storing bitmap near superblock  (I have this working)
  - hot-add bitmap                  (I've started on this)
  - support for raid5/6 and hopefully raid10.  (still to come)

and I would really like
   only-kick-drives-on-write-errors-not-read-errors

to be the next priority.  After that, I will definitely look at async
writes.

NeilBrown
