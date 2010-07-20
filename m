From: Konstantin Svist <fry.kun@gmail.com>
Subject: Re: [SOLVED] Re: messed up changing chunk size
Date: Tue, 20 Jul 2010 10:01:52 -0700
Message-ID: <4C45D680.7090208@gmail.com>
References: <4C439D19.4070906@gmail.com> <4C44939A.1060200@gmail.com> <4C4525E8.2010702@relevad.com> <4C454246.3030703@gmail.com> <4C45CF22.4060900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C45CF22.4060900@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 07/20/2010 09:30 AM, Konstantin Svist wrote:
> For some reason, mdadm refused to resize back to max:
>
> # mdadm --grow -z max --backup-file=/root/grow_md0_size_back.bak /dev/md0
> mdadm: component size of /dev/md0 has been set to 293033536K
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
>       293033472 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>
>
> After stopping and re-assembling the array, though, it comes up with 
> full size but with only 3 of 4 drives:
>
> # mdadm --assemble --scan
> mdadm: /dev/md0 has been started with 3 drives (out of 4).
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sda4[0] sdc1[2] sdb1[1]
>       879100608 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>
> The array is degraded but data is all there, so I'm backing it up 
> right now. No idea why it doesn't like the 4th drive.
>

3 out of 4 was due to bad /etc/mdadm.conf -- I forgot the / in front of 
/dev/sdd1
It's now rebuilding and everything is fine so far

