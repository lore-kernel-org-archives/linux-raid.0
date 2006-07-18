From: Shai <shaibn@gmail.com>
Subject: Re: which disk the the one that data is on?
Date: Tue, 18 Jul 2006 12:23:26 +0300
Message-ID: <e3edb0fa0607180223q11193d9ey6a6569bded1feb4@mail.gmail.com>
References: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
	 <17596.41907.608404.634683@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17596.41907.608404.634683@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

So if I were to want to stop the resync process on a very large array
(1.4T), since it is in the middle of the day and makes work slower...
How can I tell which drive is the one that is being used to check all
the rest of the data? Or in other words, how can I stop the resync
process and let it cont. later?

Shai

On 7/18/06, Neil Brown <neilb@suse.de> wrote:
> On Tuesday July 18, shaibn@gmail.com wrote:
> > Hi,
> >
> > I rebooted my server today to find out that one of the arrays is being
> > re-synced (see output below)
> > .
> > 1. What does the (S) to the right of hdh1[5](S) mean?
>
> Spare.
>
> > 2. How do I know, from this output, which disk is the one holding the
> > most current data and from which all the other drives are syncing
> > from? Or are they all containing the data and this sync process is
> > something else? Maybe I'm just not understanding what is being done
> > exactly?
>
> This is raid5.  The data is distributed over all of the drives.
> There are also 'parity' blocks used for coping with missing devices.
> This 'resync' process is checking that the parity blocks are all
> correct and will correct any that are wrong.
>
> NeilBrown
>
>
> >
> > Thanks in advance for the help.
> >
> > Shai
> > ---
> >
> > md0 : active raid5 hdd1[1] hdc1[0] hdh1[5](S) hdg1[4] hdf1[3] hde1[2]
> >       781433344 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
> >       [=>...................]  resync =  5.1% (9965184/195358336)
> > finish=180.5min speed=17110K/sec
> >
>
