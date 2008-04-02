From: "Conway S. Smith" <beolach@gmail.com>
Subject: Re: (was: Re: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10
 raptors])
Date: Wed, 2 Apr 2008 08:02:06 -0600
Message-ID: <20080402080206.6bd8ea65@hardcode42.net>
References: <aebf5d970804012126o1e8a7d66qf80f081efcf0ec60@mail.gmail.com>
	<alpine.DEB.1.00.0804020812170.4198@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0804020812170.4198@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2 Apr 2008 08:16:16 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> 
> 
> On Tue, 1 Apr 2008, Beolach wrote:
> 
<snip>
> >
> > Also, would you be willing to share your script for averaging 3
> > bonnie++ runs?  I'm too lazy to write my own, so I've just been
> > doing single runs.
> 
> I do not have a single script to do it actually, it works like this:
> 
> # Run bonnie 3 times (script).
> for i in 1 2 3
> do
>    /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n
> 16:100000:16:64 > $HOME/test"$i".txt 2>&1 done
> 
> # then get the results
> $ cat test* | grep ,
> p34,16G,80170,99,261521,43,109222,14,82516,99,527121,39,864.3,1,16:100000:16/6411428,83,+++++,+++,6603,30,7780,56,+++++,+++,8959,45
> p34,16G,79428,99,266452,44,111190,14,82087,99,535667,39,884.3,1,16:100000:16/643388,26,+++++,+++,7185,34,6364,46,+++++,+++,4040,22
> p34,16G,78346,99,255350,42,111591,14,82153,99,527210,38,850.4,1,16:100000:16/642916,21,+++++,+++,18495,81,5614,41,+++++,+++,15727,83
> 
> $ cat test* | grep , > results
> 
> $ avgbonnie results 
> p34,16G,79314.7,99,261108,43,110668,14,82252,99,529999,38.6667,866.333,1,16:100000:16/64,5910.67,43.3333,0,0,10761,48.3333,6586,47.6667,0,0,9575.33,50
> 
> Nothing special for the average, just a long awk statement
> hardcoded for 3 runs:
> 
> grep ',' "$1" | awk -F',' '{print $1, $2, c += $3/3, d += $4/3, e
> += $5/3, f += $6/3, g += $7/3, h += $8/3, i += $9/3, j += $10/3, k
> += $11/3, l += $12/3, m += $13/3, n += $14/3, $15, p += $16/3, q +=
> $17/3, r += $18/3, s += $19/3, t += $20/3, u += $21/3, v += $22/3,
> w += $23/3, x += $24/3, y += $25/3, z += $26/3, aa += $27/3}' |
> tail -n 1 | sed 's/\ /,/g'
> 
> $ grep ',' results | awk -F',' '{print $1, $2, c += $3/3, d +=
> $4/3, e += $5/3, f += $6/3, g += $7/3, h += $8/3, i += $9/3, j +=
> $10/3, k += $11/3, l += $12/3, m += $13/3, n += $14/3, $15, p +=
> $16/3, q += $17/3, r += $18/3, s += $19/3, t += $20/3, u += $21/3,
> v += $22/3, w += $23/3, x += $24/3, y += $25/3, z += $26/3, aa +=
> $27/3}' | tail -n 1 | sed 's/\ /,/g'
> p34,16G,79314.7,99,261108,43,110668,14,82252,99,529999,38.6667,866.333,1,16:100000:16/64,5910.67,43.3333,0,0,10761,48.3333,6586,47.6667,0,0,9575.33,50
> 
> Hope this helps..
> 

Thanks! Although now I'll have to get around to learning awk so I can
understand that. ;-)

> >
> > [1] My bonnie++ results:
> > <http://www.xmission.com/~beolach/bonnie++_4disk-ls.html>
> Intriguing results you have there, nice sequential read speed.
> What FS are you using?
> Any special options?

XFS, no special mkfs options, noatime,nodiratime mount options.

> What read-ahead are you using?
> What is your stripe_cache_size?
> These heavily affect performance.
> 

I haven't tried tweaking these yet.  Are they likely to change which
chunksize performs best?  I was thinking I'd figure out a chunksize,
and then look at other performance tweaks.  But I'm worried that I
might later find out a different chunksize would have been better,
and chunksize is much harder to change than read-ahead.

$ blockdev --getra /dev/md1
3072
$ cat /sys/block/md1/md/stripe_cache_size
256


Thanks,
Conway S. Smith
