From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md device stuck!
Date: Wed, 31 Jul 2002 09:16:12 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15687.7740.359627.282411@notabene.cse.unsw.edu.au>
References: <15685.5438.362051.450805@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.32.0207291541380.4476-100000@dope.pingdynasty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin@hack.org on Monday July 29
To: martin@hack.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 29, martin@hack.org wrote:
> 
> hiya,
> 
> has anyone come across the problem of md devices getting 'stuck'?
> currently, if i try to mount/umount md2, or run either raidstop or
> mdadm --stop, the commands just hang and /proc/mdstat gives no indication
> of anything going on. (the only way to kill the command seems to be to
> SIGKILL its parent process...)
> 
> any ideas?

You didn't say which kernel you are running ......

> 
> dope:~ # ps -flw
>   F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
> 004 S root      4414  4413  0  72   0 -   506 norita 15:33 pts/4    00:00:00 -bash
> 000 D root      4438  4414  0  72   0 -   220 ptrace 15:34 pts/4    00:00:00 mdadm --stop /dev/md2

and you don't have a correct System.map file.  There is no-way that
mdadm will be blocked in ptrace.

NeilBrown
