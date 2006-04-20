From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: linear writes to raid5
Date: Thu, 20 Apr 2006 12:22:56 +0400
Message-ID: <444744E0.7010509@tls.msk.ru>
References: <m37j60udi8.fsf@bzzz.home.net>	<17465.43983.345817.253532@cse.unsw.edu.au>	<m3y7ybrffe.fsf@bzzz.home.net>	<17468.18087.901186.523228@cse.unsw.edu.au>	<m3hd4yrdx3.fsf@bzzz.home.net>	<17474.53696.831154.37427@cse.unsw.edu.au>	<4444F7A8.7050304@tls.msk.ru> <17478.52089.452739.896039@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17478.52089.452739.896039@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday April 18, mjt@tls.msk.ru wrote:
[]
>> I mean, mergeing bios into larger requests makes alot of sense between
>> a filesystem and md levels, but it makes alot less sense to do that
>> between md and physical (fsvo "physical" anyway) disks.
> 
> This seems completely backwards to me, so we must be thinking of
> different things.
> 
> Creating large requests above the md level doesn't make a lot of sense
> to me because there is a reasonable chance that md will just need to
> break the requests up again to submit to different devices lower down.
> 
> Building large requests for the physical disk makes lots of sense
> because you get much better throughput on an e.g. SCSI buss by having
> few large requests rather than many small requests.  But this building
> should be done close to the device so that as much information as
> possible is available about particular device characteristics.
> 
> What is the rationale for your position?

My rationale was that if md layer receives *write* requests not smaller
than a full stripe size, it is able to omit reading data to update, and
can just calculate new parity from the new data.  Hence, combining a
dozen small write requests coming from a filesystem to form a single
request >= full stripe size should dramatically increase performance.

Eg, when I use dd with O_DIRECT mode (oflag=direct) and experiment with
different block size, write performance increases alot when bs becomes
full stripe size.  Ofcourse it decreases again when bs is increased a
bit further (as md starts reading again, to construct parity blocks).

For read requests, it makes much less difference where to combine them.

/mjt
