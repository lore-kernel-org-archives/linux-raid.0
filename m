From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Stress testing system?
Date: Sun, 10 Oct 2004 21:36:50 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0410102122140.9395@lion.drogon.net>
References: <4167078A.3030609@robinbowes.com> <Pine.LNX.4.56.0410082257450.26162@lion.drogon.net>
 <4167264B.8070507@robinbowes.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4167264B.8070507@robinbowes.com>
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 9 Oct 2004, Robin Bowes wrote:

> I tried this - just a simple command to start with:
>
> # bonnie++ -d /home -s10 -r4 -u0
>
> This gave the following results:
>
> Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
>                      -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> dude.robinbowes 10M 11482  92 +++++ +++ +++++ +++ 15370 100 +++++ +++ 13406 124

Why are you removing the speed - is it something to be embarased about?

If it's very slow, are you sure the devices are operating in a DMA mode?
POI mode will use a lot of CPU and geneally make things really clunky..

> Is this normal? Should running bonnie++ result in the array being dirty
> and requiring resyncing?

No - but reading some of the later replies it seems it might not have been
fully synced to start with?

Have you let it sync now and run the tests again?

Ah right - I've just run that bonnie myself - it's +++'d out the times as
10MB is really too small a file to do anything accurate with and you've
told it you only have 4MB of RAM. It'll all end up in memory cache. I got
similar results with that command.

Don't bother with the -n option, and do get it to use a filesize of double
your RAM size. You really just want to move data into & out of the disks,
who cares (at this point) about actual file, seek, etc. IO. I use the
following scripts when testing:

/usr/local/bin/doBon:

  #!/bin/csh
  @ n = 1
  while (1)
    echo Pass number $n
    bonnie -u0 -g0 -n0 -s 1024
    @ n = $n + 1
  end

/usr/local/bin/doBon2:

  #!/bin/csh
  doBon & sleep 120
  doBon

and usually run a "doBon2" on each partition. Memory size here is 512MB.

Gordon

Ps. stop this with killall doBon2 ; killall doBon ; killall Bonnie
  ...  then rm the Bonnie* files...
