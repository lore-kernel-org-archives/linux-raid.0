From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [PERFORM] Postgres on RAID5
Date: Mon, 14 Mar 2005 18:49:11 -0500
Message-ID: <200503142349.j2ENnG510033@www.watkins-home.com>
References: <42361474.9060500@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <42361474.9060500@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Tokarev' <mjt@tls.msk.ru>, 'Arshavir Grigorian' <ag@m-cam.com>
Cc: linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

You said:
"If your write size is smaller than chunk_size*N (N = number of data blocks
in a stripe), in order to calculate correct parity you have to read data
from the remaining drives."

Neil explained it in this message:
http://marc.theaimsgroup.com/?l=linux-raid&m=108682190730593&w=2

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Tokarev
Sent: Monday, March 14, 2005 5:47 PM
To: Arshavir Grigorian
Cc: linux-raid@vger.kernel.org; pgsql-performance@postgresql.org
Subject: Re: [PERFORM] Postgres on RAID5

Arshavir Grigorian wrote:
> Alex Turner wrote:
> 
[]
> Well, by putting the pg_xlog directory on a separate disk/partition, I 
> was able to increase this rate to about 50 or so per second (still 
> pretty far from your numbers). Next I am going to try putting the 
> pg_xlog on a RAID1+0 array and see if that helps.

pg_xlog is written syncronously, right?  It should be, or else reliability
of the database will be at a big question...

I posted a question on Feb-22 here in linux-raid, titled "*terrible*
direct-write performance with raid5".  There's a problem with write
performance of a raid4/5/6 array, which is due to the design.

Consider raid5 array (raid4 will be exactly the same, and for raid6,
just double the parity writes) with N data block and 1 parity block.
At the time of writing a portion of data, parity block should be
updated too, to be consistent and recoverable.  And here, the size of
the write plays very significant role.  If your write size is smaller
than chunk_size*N (N = number of data blocks in a stripe), in order
to calculate correct parity you have to read data from the remaining
drives.  The only case where you don't need to read data from other
drives is when you're writing by the size of chunk_size*N, AND the
write is block-aligned.  By default, chunk_size is 64Kb (min is 4Kb).
So the only reasonable direct-write size of N drives will be 64Kb*N,
or else raid code will have to read "missing" data to calculate the
parity block.  Ofcourse, in 99% cases you're writing in much smaller
sizes, say 4Kb or so.  And here, the more drives you have, the
LESS write speed you will have.

When using the O/S buffer and filesystem cache, the system has much
more chances to re-order requests and sometimes even omit reading
entirely (when you perform many sequentional writes for example,
without sync in between), so buffered writes might be much fast.
But not direct or syncronous writes, again especially when you're
doing alot of sequential writes...

So to me it looks like an inherent problem of raid5 architecture
wrt database-like workload -- databases tends to use syncronous
or direct writes to ensure good data consistency.

For pgsql, which (i don't know for sure but reportedly) uses syncronous
writs only for the transaction log, it is a good idea to put that log
only to a raid1 or raid10 array, but NOT to raid5 array.

Just IMHO ofcourse.

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

