From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Wed, 28 Jul 2004 06:02:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040728100258.GA7982@jim.sh>
References: <20040727021209.GA19205@jim.sh> <Pine.GSO.4.33.0407271238490.25702-100000@sweetums.bluetronic.net> <20040727172028.GA27240@jim.sh> <20040727181938.GA28181@jim.sh> <20040727184836.GA28494@jim.sh> <20040728030927.GA1625@jim.sh> <41076595.7080403@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41076595.7080403@dgreaves.com>
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

> FWIW a month or so ago I used mdadm + 2.6.4 and constructed a 5x250Gb 
> RAID 5 array with one drive missing.
> When I added the missing drive and reconstruction had finished I had fs 
> corruption.
> 
> I used the reiser tools to fix it but lost an awful lot of data.
> 
> I reported it in detail here 
> [http://marc.theaimsgroup.com/?l=linux-raid&m=108687793611905&w=2] and 
> got zero response <shrug>

Yeah, I saw that posting.  For me, raid5 appears to work fine,
although like you, my faith is dropping. :)  For all I know, my RAID6
problems could also exist in the very-similar RAID5 code, but just not
show up as often.

> PS around that time there was a patch 
> [http://marc.theaimsgroup.com/?l=linux-raid&m=108635099921570&w=2]
> for a bug in the RAID5 resync code.
> it was only for the raid5.c
> It doesn't look raid5 algorithm specific ... :)

Thanks for the tip.  Unfortunately, that fix was already in the RAID6
code in 2.6.7.  Just in case, I upgraded my kernel to 2.6.8-rc2, which
includes that patch, and still have the same problem.

-jim
