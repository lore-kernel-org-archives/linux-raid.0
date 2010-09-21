From: Neil Brown <neilb@suse.de>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Wed, 22 Sep 2010 08:21:54 +1000
Message-ID: <20100922082154.6908e3c5@notabene>
References: <4C938103.1010304@seoss.co.uk>
	<20100918085925.5fee83ee@notabene>
	<4C97BD21.1040405@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C97BD21.1040405@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, mike@hartmanipulation.com
List-Id: linux-raid.ids

On Mon, 20 Sep 2010 20:59:29 +0100
Tim Small <tim@seoss.co.uk> wrote:

> 
> >  unfortunately I need more that just the set of blocked tasks to diagnose the
> >  problem.   If you could get the result of 
> >          echo t > /proc/sysrq-trigger
> >  that might help a lot.  This might be bigger than the dmesg buffer, so you
> >  might try booting with 'log_buf_len=1M' just to be sure.
> >   
> 
> 
> Hi Neil,
> 
> Thanks for the feedback.  I've stuck the sysrq-t output here:
> 
> http://buttersideup.com/files/md-raid1-lockup-lvm-snapshot/iodeadlock-sysrq-t.txt

Unfortunately this log is not complete.  As I suggested, you need to boot
with a larger log_buf_len  (you seem to have 128K) to get able to capture the
whole thing.

NeilBrown


> 
> ... this was soon after the io to md2 stopped - md0 seems fine...
> 
> oldshoreham:~# cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sda6[0] sdb6[1]
>       404600128 blocks [2/2] [UU]
>       [>....................]  resync =  0.1% (437056/404600128)
> finish=343321.2min speed=19K/sec
> 
> 
> ... I also tried an older Debian 5.0.x kernel from Mar 2009, which is a
> less-patched 2.6.26, and got the same results.  2.6.32 hasn't deadlocked
> after 10 minutes (2.6.26 usually does within a minute of boot-up), so
> I'll leave it re-syncing overnight...
> 
> Cheers!
> 
> Tim.
> 

