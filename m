From: Brad Campbell <brad@wasp.net.au>
Subject: Re: raid5 code ok with 2TB + ?
Date: Sun, 28 Nov 2004 14:57:48 +0400
Message-ID: <41A9AF2C.5010706@wasp.net.au>
References: <Pine.LNX.4.61.0411281146490.17548@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411281146490.17548@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stephan van Hienen wrote:
> in the past the raid5 code was 32bits internal
> and the limit was 2TB
> 
> is this fixed in the 2.6.x ?

I hope so, I have been using it on a 2.2TB raid-5 for months now. (I have completely filled the 
partition and e2fsck it monthly so I would hope any glitches should have surfaced by now)

brad@srv:~$ cat /proc/mdstat
Personalities : [raid0] [raid5] [raid6]
md2 : active raid5 sdl[0] sdm[2] sdk[1]
       488396800 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid5 sda1[0] sdj1[9] sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
       2206003968 blocks level 5, 128k chunk, algorithm 0 [10/10] [UUUUUUUUUU]


-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
