From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Fri, 9 Dec 2005 10:47:55 +1100
Message-ID: <17304.50731.507934.131132@cse.unsw.edu.au>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
	<17302.10018.330421.986669@cse.unsw.edu.au>
	<dc164f000512062258r21ebb844w4b59238612635d7f@mail.gmail.com>
	<17303.44330.447062.271960@cse.unsw.edu.au>
	<dc164f000512072201w1779863bw1ac1d7b14a5a52ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Milo on Wednesday December 7
Sender: linux-raid-owner@vger.kernel.org
To: Milo <search.lists@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 7, search.lists@gmail.com wrote:
> >
> > Yes, that is very helpful.
> >
> > The drive is not being assembled successfully.
> > When you try to mount it, a raid bug (which has since been fixed)
> > causes the mount processed to crash.
> > You should be able to assemble the array with:
> >
> >   mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1
> >
> > Please try that, then take a copy of
> >   cat /proc/mdstat
> >   mdadm -D /dev/md0
> 
> # mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1
> mdadm: /dev/md0 has been started with 2 drives (out of 3).
> # cat /proc/mdstat
> Personalities : [raid5]
> md0 : active raid5 sdb1[1] sdc1[2]
>       490191104 blocks level 5, 128k chunk, algorithm 2 [3/2] [_UU]
> 
> unused devices: <none>
> 
> then mdadm -D /dev/md0 hangs, then i make another trace ...
> http://www.lebox.org/milan/debug/dmesg.1134020701
> 

It looks like the computer was already quite sick.  It probably tried
to assemble the array at boot, failed, and left things in an
unfortunate state.
Can you boot with
   raid=noautodetect

And then try the 'mdadm ..' command again?

Thanks,
NeilBrown
