From: Tim Southerwood <ts@dionic.net>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Thu, 28 Feb 2008 11:22:26 +0000
Message-ID: <47C69972.50508@dionic.net>
References: <1204195554.16924.16.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204195554.16924.16.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: Franck Routier <franck.routier@axege.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Franck Routier wrote:
> Hi,
> 
> I am installing a database (postgresql) server.
> I am considering two options:
> - either setup two 6 disks raid10 arrays
> - or setup three 4 disks raid10 arrays
> 
> You guessed I have 12 disks :)
> 
> Raw performance is better on 6 disks arrays, but having 3 arrays allows
> me to setup 3 tablespaces and maybe to achieve better parallelism.
> 
> I am under the impression that I will get better results with requests
> spread over 3 less effective arrays rather than two slightly more effive
> one.
> 
> Does it make any sense, or am I totally missing the point ?
> 
> Thanks,
> Franck
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi

No, it makes total sense.

Having just done a lot of work on optimising Postgresql:

How many distinct table spaces depends on your expected usage pattern - 
ie if you have one table that is hammered for updates all the time you 
might benefit from having the table storage on a physically separate 
tablespace to any indexes for that table.

If you are hammering some tables for updates whilst querying other 
tables at a high rate, placing the updating tables on a different 
tablespace to the ones you are querying may benefit.

The nice thing about Postgresql 8.1 upwards (at least I haven't tried 
this under 8.0) is that you can ALTER TABLE|INDEX to use a different 
tablespace at run time on a live database, so experimentation is easy.

However, the single biggest improvement I found was to ensure that the 
WAL is redirected to a otherwise quiescent disk.

In my case, I arranged two physically separate storage volumes thus:

VOL1: OS (/) + WAL
VOL2: DB storage (minus WAL) + /var/log

Taking /var/log off VOL1 rendered it fairly quiet after all applications 
had started and having the WAL on a quiet volume gave me a tenfold 
improvement in INSERT rate, so not insignificant.

If you are expecting heavy insert/update accesses, I would suggest you 
take two disks off as a RAID1 mirror and devote them entirely to the WAL.

Cheers

Tim
