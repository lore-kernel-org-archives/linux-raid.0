From: Tim Small <tim@seoss.co.uk>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 21 Sep 2010 22:02:25 +0100
Message-ID: <4C991D61.1040400@seoss.co.uk>
References: <4C938103.1010304@seoss.co.uk> <20100918085925.5fee83ee@notabene> <4C97BD21.1040405@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C97BD21.1040405@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tim Small wrote:
> http://buttersideup.com/files/md-raid1-lockup-lvm-snapshot/iodeadlock-sysrq-t.txt
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

2.6.32 resynced to completion, but if possible I'd really like to get
2.6.26 running on this box, as it uses openvz, and the 2.6.32 openvz
patches are still pretty green, I think.  Is their anything in the
sysrq-t output in that link of any use?  Are there any patches I should
try, or would it be better to start bisecting between 2.6.26 and 2.6.32
(assuming I can reproduce the problem without the load pattern which
openvz is producing - which I probably can).

Cheers,

Tim.


-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

