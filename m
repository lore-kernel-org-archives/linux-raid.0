From: Neil Brown <neilb@suse.de>
Subject: Re: which disk the the one that data is on?
Date: Tue, 18 Jul 2006 19:02:43 +1000
Message-ID: <17596.41907.608404.634683@cse.unsw.edu.au>
References: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Shai on Tuesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 18, shaibn@gmail.com wrote:
> Hi,
> 
> I rebooted my server today to find out that one of the arrays is being
> re-synced (see output below)
> .
> 1. What does the (S) to the right of hdh1[5](S) mean?

Spare.

> 2. How do I know, from this output, which disk is the one holding the
> most current data and from which all the other drives are syncing
> from? Or are they all containing the data and this sync process is
> something else? Maybe I'm just not understanding what is being done
> exactly?

This is raid5.  The data is distributed over all of the drives.
There are also 'parity' blocks used for coping with missing devices.
This 'resync' process is checking that the parity blocks are all
correct and will correct any that are wrong.

NeilBrown


> 
> Thanks in advance for the help.
> 
> Shai
> ---
> 
> md0 : active raid5 hdd1[1] hdc1[0] hdh1[5](S) hdg1[4] hdf1[3] hde1[2]
>       781433344 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>       [=>...................]  resync =  5.1% (9965184/195358336)
> finish=180.5min speed=17110K/sec
> 
