From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Wed, 24 Oct 2007 09:12:58 +0200
Message-ID: <471EF07A.5040007@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	 <47181CB2.1060602@tmr.com>  <471864F8.9010209@systella.fr>	 <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>	 <4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr>	 <47191855.4020402@systella.fr>  <47191BCF.2000908@systella.fr> <1192828331.30976.26.camel@dwillia2-linux.ch.intel.com> <4719B6DE.9040403@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4719B6DE.9040403@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

	Hello,

	Any news about this trouble ? Any idea ? I'm trying to fix it, but I 
don't see any specific interaction between raid5 and istd. Does anyone 
try to reproduce this bug on another arch than sparc64 ? I only use 
sparc32 and 64 servers and I cannot test on other archs. Of course, I 
have a laptop, but I cannot create a raid5 array on its internal HD to 
test this configuration ;-)

	Please note that I won't read my mails until next saturday morning (CEST).

> After disconnection of iSCSI target :
> 
> Tasks: 232 total,   7 running, 224 sleeping,   0 stopped,   1 zombie
> Cpu(s):  0.0%us, 15.2%sy,  0.0%ni, 84.3%id,  0.0%wa,  0.1%hi,  0.3%si, 
> 0.0%st
> Mem:   4139032k total,  4127584k used,    11448k free,    95752k buffers
> Swap:  7815536k total,        0k used,  7815536k free,  3758792k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  9738 root      15  -5     0    0    0 R  100  0.0   4:56.82 md_d0_raid5
>  9774 root      15  -5     0    0    0 R  100  0.0   5:52.41 istd1
>  9739 root      15  -5     0    0    0 R   14  0.0   0:28.90 md_d0_resync
>  9916 root      20   0  3248 1544 1120 R    2  0.0   0:00.56 top
>  4129 root      20   0 41648 5024 2432 S    0  0.1   2:56.17 
> fail2ban-server
>     1 root      20   0  2576  960  816 S    0  0.0   0:01.58 init
>     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd
>     3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/0
>     4 root      15  -5     0    0    0 S    0  0.0   0:00.02 ksoftirqd/0
>     5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/1
>     6 root      15  -5     0    0    0 S    0  0.0   0:00.00 ksoftirqd/1

	Regards,

	JKB
