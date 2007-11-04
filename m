From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Sun, 04 Nov 2007 14:40:11 +0100
Message-ID: <472DCBBB.1040806@systella.fr>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> # ps auxww | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
> 
> After several days/weeks, this is the second time this has happened, 
> while doing regular file I/O (decompressing a file), everything on the 
> device went into D-state.

	Same observation here (kernel 2.6.23). I can see this bug when I try to 
synchronize a raid1 volume over iSCSI (each element is a raid5 volume), 
or sometimes only with a 1,5 TB raid5 volume. When this bug occurs, md 
subsystem eats 100% of one CPU and pdflush remains in D state too. What 
is your architecture ? I use two 32-threads T1000 (sparc64), and I'm 
trying to determine if this bug is arch specific.

	Regards,

	JKB
