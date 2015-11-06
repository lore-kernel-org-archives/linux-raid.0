From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: Re: RAID6 reshape stalls immediately
Date: Fri, 6 Nov 2015 22:48:49 +0900
Message-ID: <563CAFC1.2080708@gmail.com>
References: <84a8qtgwqk.wl-peter.chubb@nicta.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84a8qtgwqk.wl-peter.chubb@nicta.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Chubb <peter.chubb@nicta.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Peter,

What happening on the root partition where you are trying to take a backup?

Any I/O, filesize etc?

Also could you share the output of mdadm --examine <all of your 6 raid 
members individually?

On 11/5/2015 8:39 AM, Peter Chubb wrote:
> Hi Folks,
>     I added two disks to my RAID5 array then attempted to reshape it to
>     RAID 6.  And it has been sitting on 0% complete, with no disk I/O
>     for 24 hours now.
>
>     Is there any way to kick the reshape process?
>
> /proc/mdstat is:
>
>    Personalities : [raid6] [raid5] [raid4]
>    md0 : active raid6 sdi1[6] sdh1[5] sdd1[4] sde1[2] sdb1[1] sda1[0]
>        5860122624 blocks super 1.2 level 6, 512k chunk, algorithm 18 [6/5] [UUUU_U]
>        [>....................]  reshape =  0.0% (0/1953374208) finish=1308.7min speed=24099K/sec
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>
>    unused devices: <none>
>
>
> What I did:
>    mdadm --add /dev/md0 /dev/sdh1
>    mdadm --add /dev/md0 /dev/sdi1
>    mdadm --grow /dev/md0 --level=6 --raid-devices=6 --backup-file=/root/raid5-backup
>
> dmesg reported:
> [691739.298345] md: bind<sdh1>
> [691739.364534] RAID conf printout:
> [691739.364537]  --- level:5 rd:4 wd:4
> [691739.364539]  disk 0, o:1, dev:sda1
> [691739.364540]  disk 1, o:1, dev:sdb1
> [691739.364541]  disk 2, o:1, dev:sde1
> [691739.364542]  disk 3, o:1, dev:sdd1
> [691741.832242] md: bind<sdi1>
> [691741.898470] RAID conf printout:
> [691741.898474]  --- level:5 rd:4 wd:4
> [691741.898476]  disk 0, o:1, dev:sda1
> [691741.898478]  disk 1, o:1, dev:sdb1
> [691741.898480]  disk 2, o:1, dev:sde1
> [691741.898481]  disk 3, o:1, dev:sdd1
> [691741.898482] RAID conf printout:
> [691741.898482]  --- level:5 rd:4 wd:4
> [691741.898484]  disk 0, o:1, dev:sda1
> [691741.898485]  disk 1, o:1, dev:sdb1
> [691741.898486]  disk 2, o:1, dev:sde1
> [691741.898487]  disk 3, o:1, dev:sdd1
> [691805.469105] md/raid:md0: device sdd1 operational as raid disk 3
> [691805.469110] md/raid:md0: device sde1 operational as raid disk 2
> [691805.469111] md/raid:md0: device sdb1 operational as raid disk 1
> [691805.469112] md/raid:md0: device sda1 operational as raid disk 0
> [691805.469551] md/raid:md0: allocated 5424kB
> [691805.506035] md/raid:md0: raid level 6 active with 4 out of 5 devices, algori
> thm 18
> [691805.506050] RAID conf printout:
> [691805.506051]  --- level:6 rd:5 wd:4
> [691805.506053]  disk 0, o:1, dev:sda1
> [691805.506054]  disk 1, o:1, dev:sdb1
> [691805.506055]  disk 2, o:1, dev:sde1
> [691805.506056]  disk 3, o:1, dev:sdd1
> [691805.847329] RAID conf printout:
> [691805.847333]  --- level:6 rd:6 wd:5
> [691805.847335]  disk 0, o:1, dev:sda1
> [691805.847336]  disk 1, o:1, dev:sdb1
> [691805.847337]  disk 2, o:1, dev:sde1
> [691805.847338]  disk 3, o:1, dev:sdd1
> [691805.847340]  disk 4, o:1, dev:sdi1
> [691805.847350] RAID conf printout:
> [691805.847350]  --- level:6 rd:6 wd:5
> [691805.847351]  disk 0, o:1, dev:sda1
> [691805.847352]  disk 1, o:1, dev:sdb1
> [691805.847353]  disk 2, o:1, dev:sde1
> [691805.847354]  disk 3, o:1, dev:sdd1
> [691805.847354]  disk 4, o:1, dev:sdi1
> [691805.847355]  disk 5, o:1, dev:sdh1
> [691805.847424] md: reshape of RAID array md0
> [691805.847426] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [691805.847428] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> [691805.847439] md: using 128k window, over a total of 1953374208k.
>
> And nothing since.
>
