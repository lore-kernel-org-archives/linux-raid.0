From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Forcing raid1 resync
Date: Tue, 17 Aug 2004 07:46:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16673.11033.677046.5702@cse.unsw.edu.au>
References: <8075D5C3061B9441944E1373776451186488C0@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Monday August 16
To: "Rechenberg, Andrew" <ARechenberg@sfg.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 16, ARechenberg@sfg.com wrote:
> 
> And I will need to use mdadm or raidhotadd to add /dev/sdao1 back into
> the array.  When I add a device back into the array the reconstruction
> doesn't start immediately and/or if another reconstruction is underway,
> the new recontruction will not occur until the first one has completed.
> 
> Is this behavior expected/by design?  Waiting for 26 arrays to
> reconstruct one at a time is painfully slow.  When I created the arrays
> they all started to sync at the same time so I know the RAID code will
> sync more than one at a time, and when my box came up yesterday after a
> hard power cycle, about 5 arrays started syncing, but the rest waited
> until those were finished and then synced one at a time.

In 2.4, resyncing of multiple arrays can happen in parallel, providing
they don't share physical drives, but reconstruction (i.e. after
hot-add) does not.  I believe that this is accidental rather than
deliberate.  
In 2.6, both resync and reconstruction can happen in parallel (again,
providing there is no sharing of drives).

However after a crash, you should not need to hot add any drives.  All
arrays should still be intact, but will need to be resynced (though in
2.6, this is sometimes avoided).

Maybe there is something wrong with your configuration that means that
some arrays are never assembled correctly.

If you are using "raidstart" to start your arrays, my advice is:
Don't.

If you are using in-kernel autodetect, then make sure that every
partition has the correct partition type (0xFD I think), otherwise you
will certainly get exactly the results you see.

NeilBrown
