From: Brad Campbell <brad@wasp.net.au>
Subject: Re: mdstat: resync=DELAYED
Date: Tue, 28 Jun 2005 01:42:32 +0400
Message-ID: <42C072C8.8090000@wasp.net.au>
References: <200506271425.36814.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506271425.36814.eric@pretorious.net>
Sender: linux-raid-owner@vger.kernel.org
To: eric@pretorious.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric Pretorious wrote:
> Hello, All:
> 
> I'm configuring a SuperMicro 5013CM8 (with on-board Adaptec AIC-7902B U320 
> SCSI controller controlling two Seagate ST373207LC 73GB U320 hard-drives) and 
> am experiencing random crashes: The system ocassionally blurts out a bunch of 
> stuff about the SCSI system and then freezes.

> md3 : active raid1 sdb6[1] sda6[0]
>       1052160 blocks [2/2] [UU]
>         resync=DELAYED
> md4 : active raid1 sdb7[1] sda7[0]
>       50660864 blocks [2/2] [UU]
>       [======>..............]  resync = 30.4% (15410224/50660864) 
> finish=56.9min speed=10315K/sec
> 
> What does this mean? How can I fix it?
> 

That in itself is not a problem.
The raid subsystem is not going to resync more than one array at a time here, or else your drive 
heads would thrash themselves silly. It will progress its way up the list as each resync completes.

A dead restart on my old server used to do exactly the same thing.
As for your SCSI problems, I'm afraid I can't help.

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
