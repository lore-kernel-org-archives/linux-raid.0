From: Eric Sandall <eric@sandall.us>
Subject: RE: mdadm memory leak?
Date: Tue, 5 Jul 2005 08:49:49 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0507050838200.15691@cerberus>
References: <200507050459.j654xlE06886@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200507050459.j654xlE06886@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'David Kowis' <dkowis@shlrm.org>, linux-raid@vger.kernel.org, 'Eric Sandall' <eric@sandall.us>
List-Id: linux-raid.ids

On Tue, 5 Jul 2005, Guy wrote:
> Run "ipcs" to see if you have shared memory usage that seems wrong, or
> grows.
>
> # ipcs -m
>
> ------ Shared Memory Segments --------
> key        shmid      owner      perms      bytes      nattch     status

$ ipcs -m

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch
status
0x73657469 0          nobody    666        131224     1

(probably from my mysql service)

> I have none, but I don't have a database.  Databases I have used on other
> systems tend to use a lot of shared memory.
>
> Also, if you were really out of memory, you would have active swapping.
>
> It is normal for the buffer cache to use most "unused" memory, so it would
> seem like you have almost none free, but the buffer cache will give up
> memory when needed.  I think you have another problem, not memory related.
> Also, you can stop mdadm from running.  The system will still work, just not
> monitor the arrays.  If you really think it is mdadm related, kill it.  Or
> use "/etc/init.d/mdmonitor stop".  At least as a test.

I am not running the mdadm monitor process (not sure about David Kowis).

> Run top, look at this line:
> Mem: 515296k av, 508128k used, 7168k free, 0k shrd,  128412k buff

Mem: 905948k total,   844084k used,    61864k free,    57648k buffers

(I guess my range is 2Mb-60Mb, not -40Mb as I reported earlier.
Granted I'm running less right now to try and ease the load...).

> I think buff (128412k) is the amount of "unused" memory.  But not sure.  I
> never had a memory issue with Linux, so have not researched this.  But I
> have on other Unixes.

Me either, until recently. I don't recall when this started happening,
but after talking with David Kowis it seems that it happened when we
both went from using raidtools to mdadm for our RAID-1 arrays.
<snip>

-sandalle

-- 
Eric Sandall                     |  Source Mage GNU/Linux Developer
eric@sandall.us                  |  http://www.sourcemage.org/
http://eric.sandall.us/          |  SysAdmin @ Inst. Shock Physics @ WSU
http://counter.li.org/  #196285  |  http://www.shock.wsu.edu/
