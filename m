From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Stress testing system?
Date: Sun, 10 Oct 2004 18:38:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410102239.i9AMd3N00634@www.watkins-home.com>
References: <4169AB0B.1040709@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4169AB0B.1040709@robinbowes.com>
To: 'Robin Bowes' <robin-lists@robinbowes.com>, 'Gordon Henderson' <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My system is a 500 Mhz P3 with 2 CPUs and 512 Meg ram.
My array is faster!  Hehe :)

I have a 14 disk raid5 array.  18 Gig SCSI disks, 3 SCSI buses.

bonnie++ -u0 -g0 -n0 -s 1024
Version  1.03 ------Sequential Output------ --Sequential Input- --Random-
              -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine  Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
watkins-ho 1G  3293  97 34587  89 22306  53  3549  99 67492  63 500.1   9
dude.ro 3096M 13081  95 34159  75 12617  21 15311  92 40429  30 436.1   3

2 at the same time.  This used both CPUs.  Over 100 Meg per second reads!
watkins-ho 1G  3091  85 18593  44  9733  24  3443  97 59895  60 249.6   6
watkins-ho 1G  2980  87 21176  54 10167  23  3478  99 44525  44 384.2   9
               ----     -----     -----      ----    ------     -----
Total          6071     39769     19900      6921    104420     633.8

You win on "Per Chr", this is CPU bound since it reads only 1 byte at a
time.  This is more of a CPU speed test than a disk speed test, IMHO.
During the "Per Chr" test, only 1 CPU had a load, it was at about 100%.
My guess is you have a real computer!  Maybe 1.5 Ghz.

In the other tests your CPU usage was lower, which is good for you.

Ramdom seeks... My guess is having 14 moving heads helps me a lot on this
one!  Since my disks are old.  But they are 10,000 RPM.

The bottom line:  I don't know if my array is considered fast.  I bet my
array is slow.  Today disks are so much faster than what I have.  But I have
more of them which helps performance.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Bowes
Sent: Sunday, October 10, 2004 5:35 PM
To: Gordon Henderson
Cc: linux-raid@vger.kernel.org
Subject: Re: Stress testing system?

Gordon Henderson wrote:
> On Sat, 9 Oct 2004, Robin Bowes wrote:
>>Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
>>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
>>Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
>>dude.robinbowes 10M 11482  92 +++++ +++ +++++ +++ 15370 100 +++++ +++
13406 124
> 
> 
> Why are you removing the speed - is it something to be embarased about?

As you found out, bonnie does this without any carbon-based intervention!

>>Is this normal? Should running bonnie++ result in the array being dirty
>>and requiring resyncing?
> 
> 
> No - but reading some of the later replies it seems it might not have been
> fully synced to start with?

On reflection, I'm pretty sure it wasn't. It is now.

> Have you let it sync now and run the tests again?

Yes. It was faster when the array had re-synced :)

> Ah right - I've just run that bonnie myself - it's +++'d out the times as
> 10MB is really too small a file to do anything accurate with and you've
> told it you only have 4MB of RAM. It'll all end up in memory cache. I got
> similar results with that command.
> 
> Don't bother with the -n option, and do get it to use a filesize of double
> your RAM size. You really just want to move data into & out of the disks,
> who cares (at this point) about actual file, seek, etc. IO. I use the
> following scripts when testing:
> 
> /usr/local/bin/doBon:
> 
>   #!/bin/csh
>   @ n = 1
>   while (1)
>     echo Pass number $n
>     bonnie -u0 -g0 -n0 -s 1024
>     @ n = $n + 1
>   end
> 
> /usr/local/bin/doBon2:
> 
>   #!/bin/csh
>   doBon & sleep 120
>   doBon
> 
> and usually run a "doBon2" on each partition. Memory size here is 512MB.

OK, I've tried:

    bonnie++ -d /home -u0 -g0 -n0 -s 3096

(I've got 1.5G of RAM here - RAM's so cheap it's daft not to!)

This gave the following results:

Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
dude.robinbow 3096M 13081  95 34159  75 12617  21 15311  92 40429  30 436.1
3
dude.robinbowes.com,3096M,13081,95,34159,75,12617,21,15311,92,40429,30,436.1
,3,,,,,,,,,,,,,

I don't actually know what the figures mean - is this fast??

R.
-- 
http://robinbowes.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

