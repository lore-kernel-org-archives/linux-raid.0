From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Stress testing system?
Date: Sun, 10 Oct 2004 22:35:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4169AB0B.1040709@robinbowes.com>
References: <4167078A.3030609@robinbowes.com> <Pine.LNX.4.56.0410082257450.26162@lion.drogon.net> <4167264B.8070507@robinbowes.com> <Pine.LNX.4.56.0410102122140.9395@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0410102122140.9395@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> On Sat, 9 Oct 2004, Robin Bowes wrote:
>>Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
>>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
>>Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>>dude.robinbowes 10M 11482  92 +++++ +++ +++++ +++ 15370 100 +++++ +++ 13406 124
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

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
dude.robinbow 3096M 13081  95 34159  75 12617  21 15311  92 40429  30 436.1   3
dude.robinbowes.com,3096M,13081,95,34159,75,12617,21,15311,92,40429,30,436.1,3,,,,,,,,,,,,,

I don't actually know what the figures mean - is this fast??

R.
-- 
http://robinbowes.com

