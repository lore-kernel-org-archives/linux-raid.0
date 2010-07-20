From: Konstantin Svist <fry.kun@gmail.com>
Subject: [SOLVED] Re: messed up changing chunk size
Date: Tue, 20 Jul 2010 09:30:26 -0700
Message-ID: <4C45CF22.4060900@gmail.com>
References: <4C439D19.4070906@gmail.com> <4C44939A.1060200@gmail.com> <4C4525E8.2010702@relevad.com> <4C454246.3030703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C454246.3030703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  On 07/19/2010 11:29 PM, Konstantin Svist wrote:
>  On 07/19/2010 09:28 PM, Konstantin Svist wrote:
>> Can someone confirm that this command should work to revert the size?
>> mdadm --grow -z 879100608 
>> --backup-file=/root/grow_md0_size_revert.bak /dev/md0
>
> Finally sat down and thought about it - created a temporary raid using 
> /dev/ram## and copied some files to it, did the same operations on it.
> Amazingly, all the files came back. Will see if the real thing works too

For some reason, mdadm refused to resize back to max:

# mdadm --grow -z max --backup-file=/root/grow_md0_size_back.bak /dev/md0
mdadm: component size of /dev/md0 has been set to 293033536K
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
       293033472 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]


After stopping and re-assembling the array, though, it comes up with 
full size but with only 3 of 4 drives:

# mdadm --assemble --scan
mdadm: /dev/md0 has been started with 3 drives (out of 4).
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda4[0] sdc1[2] sdb1[1]
       879100608 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

The array is degraded but data is all there, so I'm backing it up right 
now. No idea why it doesn't like the 4th drive.
