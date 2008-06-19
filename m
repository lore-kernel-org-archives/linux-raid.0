From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: making a spare actie
Date: Thu, 19 Jun 2008 21:45:03 +1000
Message-ID: <18522.18111.182249.694308@notabene.brown>
References: <485A259B.9040106@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Buckingham on Thursday June 19
Sender: linux-raid-owner@vger.kernel.org
To: jbuckingham@blueyonder.co.uk
Cc: linux-raid@vger.kernel.org, Jon Buckingham <jon.buckingham@hp.com>
List-Id: linux-raid.ids

On Thursday June 19, jbuckingham@blueyonder.co.uk wrote:
> I have also done
> mdadm /dev/md0 -a /dev/sdb5
> and this results in a recovery...
> 
> nas:~ # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb5[4] sda5[0] sdd5[3] sdc5[2]
>        733142016 blocks level 5, 64k chunk, algorithm 2 [4/3] [U_UU]
>        [=>...................]  recovery =  7.3% (17900780/244380672) finish=174.1min speed=21666K/sec
> 
> unused devices: <none>
> 
> Which I've been through before, but still ends up as a spare.

That suggests that it hits some IO error during recovery and aborts.

Are there any kernel log messages during the time that it is
recovering?

NeilBrown
