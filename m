From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Resize on dirty array?
Date: Wed, 9 Aug 2006 09:05:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
References: <44D7DC93.2070905@net1plus.com>  <17623.57067.835826.446152@cse.unsw.edu.au>
  <44D8E535.9080208@net1plus.com>  <17625.24594.568139.430440@cse.unsw.edu.au>
  <44D9C6F5.7070501@net1plus.com> <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> failure).  In the future, is there a way to help prevent this?

sure; periodic scans (perhaps smartctl) of your disks would prevent it.
I suspect that throttling the rebuild rate is also often a good idea
if there's any question about disk reliability.

> RAID is no excuse for backups.

I wish people would quit saying this: not only is it not helpful,
but it's also wrong.  a traditional backup is nothing more than a 
strangely async raid1, with the same space inefficiency.  tape is 
not the answer, and getting more not.  the idea of a periodic snapshot
to media which is located apart and not under the same load as the 
primary copy is a good one, but not cheap or easy.  backups are also
often file-based, which is handy but orthogonal to being raid
(or incremental, for that matter).  and backups don't mean you can 
avoid the cold calculation of how much reliability you want to buy.
_that_ is how you should choose your storage architecture...

regards, mark hahn.
