From: "Corey McGuire" <coreyfro@coreyfro.com>
Subject: re: RAID5 causing lockups
Date: Thu, 26 Jun 2003 22:02:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306262202290330.05EDD355@ilneval.coreyfro.com>
References: <200306261034300843.521256BA@shargaas.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306261034300843.521256BA@shargaas.coreyfro.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Whoa!!!

The strangest thing happened when I hit 12.7% on my RAID5 rebuild

  9:56pm  up 14:16,  3 users,  load average: 3.33, 2.85, 2.59
51 processes: 44 sleeping, 6 running, 1 zombie, 0 stopped
CPU states:  1.2% user, 10.3% system,  0.0% nice,  4.8% idle
Mem:   516592K av,  511704K used,    4888K free,       0K shrd,   89408K buff
Swap: 1590384K av,     264K used, 1590120K free                  394204K cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
   13 root       7 -20     0    0     0 SW<  25.8  0.0   0:26 raid1d
 4299 root       0 -20     0    0     0 SW<  22.0  0.0   0:31 raid1d
 4303 root      19  19     0    0     0 RWN  16.2  0.0   0:12 raid1syncd
    6 root       9   0     0    0     0 SW   13.4  0.0  15:41 kupdated
   14 root      20  19     0    0     0 RWN   7.6  0.0   0:11 raid1syncd
    8 root      -1 -20     0    0     0 SW<   5.7  0.0  29:37 raid5d
31151 root      10   0     0    0     0 Z     0.9  0.0   0:00 top <defunct>
31153 root      10   0   920  916   716 R     0.9  0.1   0:00 top
    1 root       9   0   504  504   440 S     0.0  0.0   2:37 init
    2 root       9   0     0    0     0 SW    0.0  0.0   0:02 keventd
    3 root      19  19     0    0     0 SWN   0.0  0.0  35:11 ksoftirqd_CPU0
    4 root       9   0     0    0     0 SW    0.0  0.0   0:37 kswapd
    5 root       9   0     0    0     0 SW    0.0  0.0   0:00 bdflush

Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md1 : active raid1 hdg1[1] hde1[0]
      2562240 blocks [2/2] [UU]
      [>....................]  resync =  2.9% (75904/2562240) finish=50.8min speed=814K/sec
md0 : active raid1 hdc1[1] hda1[0]
      2562240 blocks [2/2] [UU]
      [>....................]  resync =  2.7% (70656/2562240) finish=53.7min speed=769K/sec
md2 : active raid5 hdk3[5] hdi3[4] hdg3[3] hde3[2] hdc3[1] hda3[0](F)
      962654400 blocks level 5, 32k chunk, algorithm 0 [6/5] [_UUUUU]

unused devices: <none>

It stopped rebuilding, and moved on to my mirrors... very odd.  I'll try forcing another rebuild, but this is quasi good news.

*********** REPLY SEPARATOR  ***********

On 6/26/2003 at 10:34 AM Corey McGuire wrote:

>Much progress has been made, but success is still out of reach.
>
>First of all, 2.4.21 has been very helpful.  Feedback regarding drive
>problems is much more verbose.  I don't know who to blame, the RAID people,
>the ATA people, or the promise driver people, but immediately, I found that
>one of my controllers was hosing up the works.  I moved the devices from
>said controller to my VIA onboard controller and gained about 5MB/second on
>the rebuild speed.  I don't know if this is because 2.4.21 is faster, VIA
>is faster, I was saturating my PCI bus (since the VIA controller in on the
>Southbridge) or because I was previously getting these errors and no
>feedback.
>
>Alas, problem persists, but I have found out why (90% certain.)
>
>Now when there is a crash, the system spits out why and panics.  It looks
>to be HDA (or HDA is getting the blame) and, thanks to a seemingly
>pointless script I wrote to watch the rebuild, I found that the system dies
>at around 12.5% on the RAID5 rebuild every time.
>
>Bad disk?  Maybe, probably, but I'll keep banging my head against it for a
>while.
>
>Score,
>2.4.21 + progress script    1
>2.4.20 + crossing fingers   0
>
>I am currently running a kernel with DMA turned off by default.  This
>sounded like a good idea last night, around 4 in the morning, but now it
>sounds like an exercise in futility.  The idea came to me shortly after I
>was visited by the bovine-fairy.  She told me that everything can be fixed
>with "moon pies."  I know this apparition was real and not a hallucination
>because, until last night, I had never heard of "moon pies."  After a quick
>search of google, sure enough, moon pies; they look tasty, maybe she's
>right. 
>
>Score
>Bovine fairies              1
>Sleep depravation           0                         
>
>At any rate, by my calculations, without DMA, it will take another 12hours
>to get to the 12.5% fail point.  I should be back from work by then.
>Longevity through sloth.
>
>To answer some questions,
>
>My power situation is good.  I have had a lot more juice getting sucked
>through this power supply before.  Used to be a dual P3's with 30MM
>Peltiers and 3 10,000 RPM cheetahs.  (Peltiers are not worth it, I had to
>underclock my system and drop the voltage before it would run any cooler.)
>I think these WD's draw 20 watts peak, 14 otherwise.  My power supply is
>~400 watts.  Shouldn't be a problem, seeing as how I can run my mirrors
>just fine for days, but die after turning my stripe on for minutes.
>
>Building smaller RAID's.  Yeah, I will give that a whirl, just to make sure
>HDA is the problem.  I don't think I need to yank HDA, I'll just remove it
>from my RAIDTAB and mkraid again.
>
>One point I'd like to make; why is a drive failure killing my RAID5?  Kinda
>defeats the purpose.
>
>Here is the aforementioned script plus its results so you can see what I
>see.
>
>4tlods.sh (for the love of dog, sync!  I said I was sleep deprived.)
>
>while ((1)) ; do  top -n 1 | head -n 20 ; echo ; cat /proc/mdstat ; done
>
>2.4.21
>
>12:12am  up 19 min,  5 users,  load average: 0.87, 1.06, 0.82
>49 processes: 48 sleeping, 1 running, 0 zombie, 0 stopped
>CPU states:  1.0% user, 52.5% system,  0.0% nice, 46.3% idle
>Mem:   516592K av,   95204K used,  421388K free,       0K shrd,   52588K
>buff
>Swap: 1590384K av,       0K used, 1590384K free                   17196K
>cached
>
>  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
>    1 root       9   0   504  504   440 S     0.0  0.0   0:06 init
>    2 root       9   0     0    0     0 SW    0.0  0.0   0:00 keventd
>    3 root      19  19     0    0     0 SWN   0.0  0.0   0:00
>ksoftirqd_CPU0
>    4 root       9   0     0    0     0 SW    0.0  0.0   0:00 kswapd
>    5 root       9   0     0    0     0 SW    0.0  0.0   0:00 bdflush
>    6 root       9   0     0    0     0 SW    0.0  0.0   0:00 kupdated
>    7 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 mdrecoveryd
>    8 root       7 -20     0    0     0 SW<   0.0  0.0   6:32 raid5d
>    9 root      19  19     0    0     0 DWN   0.0  0.0   1:08 raid5syncd
>   10 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1d
>   11 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1d
>   12 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1d
>   13 root       9   0     0    0     0 SW    0.0  0.0   0:00 kreiserfsd
>
>Personalities : [raid1] [raid5]
>read_ahead 1024 sectors
>md0 : active raid1 hdc1[1] hda1[0]
>      2562240 blocks [2/2] [UU]
>
>md1 : active raid1 hdg1[1] hde1[0]
>      2562240 blocks [2/2] [UU]
>
>md3 : active raid1 hdk1[1] hdi1[0]
>      2562240 blocks [2/2] [UU]
>
>md2 : active raid5 hdk3[5] hdi3[4] hdg3[3] hde3[2] hdc3[1] hda3[0]
>      962654400 blocks level 5, 32k chunk, algorithm 0 [6/6] [UUUUUU]
>      [==>..................]  resync = 12.5% (24153592/192530880)
>finish=134.7min speed=20822K/sec
>unused devices: <none>
>
>
>2.4.21
>
>2:38am  up 19 min,  1 user,  load average: 0.63, 1.13, 0.89
>42 processes: 41 sleeping, 1 running, 0 zombie, 0 stopped
>CPU states:  0.9% user, 52.1% system,  0.0% nice, 46.8% idle
>Mem:   516592K av,   89824K used,  426768K free,       0K shrd,   57908K
>buff
>Swap:       0K av,       0K used,       0K free                   10644K
>cached
>
>  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
>    1 root       8   0   504  504   440 S     0.0  0.0   0:06 init
>    2 root       9   0     0    0     0 SW    0.0  0.0   0:00 keventd
>    3 root      19  19     0    0     0 SWN   0.0  0.0   0:00
>ksoftirqd_CPU0
>    4 root       9   0     0    0     0 SW    0.0  0.0   0:00 kswapd
>    5 root       9   0     0    0     0 SW    0.0  0.0   0:00 bdflush
>    6 root       9   0     0    0     0 SW    0.0  0.0   0:00 kupdated
>    7 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 mdrecoveryd
>    8 root      15 -20     0    0     0 SW<   0.0  0.0   6:29 raid5d
>    9 root      19  19     0    0     0 DWN   0.0  0.0   1:09 raid5syncd
>   14 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1d
>   15 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1syncd
>   16 root       9   0     0    0     0 SW    0.0  0.0   0:00 kreiserfsd
>   74 root       9   0   616  616   512 S     0.0  0.1   0:00 syslogd
>
>Personalities : [raid1] [raid5]
>read_ahead 1024 sectors
>md0 : active raid1 hdc1[1] hda1[0]
>      2562240 blocks [2/2] [UU]
>        resync=DELAYED
>md2 : active raid5 hdk3[5] hdi3[4] hdg3[3] hde3[2] hdc3[1] hda3[0]
>      962654400 blocks level 5, 32k chunk, algorithm 0 [6/6] [UUUUUU]
>      [==>..................]  resync = 12.5% (24153596/192530880)
>finish=139.2min speed=20147K/sec
>unused devices: <none>
>
>
>2.4.20
>
>3:22am  up 21 min,  1 user,  load average: 1.04, 1.31, 1.02
>47 processes: 46 sleeping, 1 running, 0 zombie, 0 stopped
>CPU states:  0.9% user, 54.7% system,  0.0% nice, 44.2% idle
>Mem:   516604K av,  125824K used,  390780K free,       0K shrd,   91628K
>buff
>Swap: 1590384K av,       0K used, 1590384K free                   10796K
>cached
>
>  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
>    1 root       9   0   504  504   440 S     0.0  0.0   0:10 init
>    2 root       9   0     0    0     0 SW    0.0  0.0   0:00 keventd
>    3 root       9   0     0    0     0 SW    0.0  0.0   0:00 kapmd
>    4 root      18  19     0    0     0 SWN   0.0  0.0   0:00
>ksoftirqd_CPU0
>    5 root       9   0     0    0     0 SW    0.0  0.0   0:00 kswapd
>    6 root       9   0     0    0     0 SW    0.0  0.0   0:00 bdflush
>    7 root       9   0     0    0     0 SW    0.0  0.0   0:00 kupdated
>    8 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 mdrecoveryd
>    9 root       4 -20     0    0     0 SW<   0.0  0.0   7:16 raid5d
>   10 root      19  19     0    0     0 DWN   0.0  0.0   1:07 raid5syncd
>   11 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1d
>   12 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1syncd
>   13 root      -1 -20     0    0     0 SW<   0.0  0.0   0:00 raid1d
>
>Personalities : [raid1] [raid5] [multipath]
>read_ahead 1024 sectors
>md0 : active raid1 hdc1[1] hda1[0]
>      2562240 blocks [2/2] [UU]
>        resync=DELAYED
>md1 : active raid1 hdg1[1] hde1[0]
>      2562240 blocks [2/2] [UU]
>        resync=DELAYED
>md3 : active raid1 hdk1[1] hdi1[0]
>      2562240 blocks [2/2] [UU]
>        resync=DELAYED
>md2 : active raid5 hdk3[5] hdi3[4] hdg3[3] hde3[2] hdc3[1] hda3[0]
>      962654400 blocks level 5, 32k chunk, algorithm 0 [6/6] [UUUUUU]
>      [==>..................]  resync = 12.5% (24155416/192530880)
>finish=181.1min speed=15487K/sec
>unused devices: <none>
>
>
>Thanks for your help everyone, I'll keep trying.
>
>
>/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\
>
>coreyfro@coreyfro.com
>http://www.coreyfro.com/
>http://stats.distributed.net/rc5-64/psummary.php3?id=196879
>ICQ : 3168059
>
>-----BEGIN GEEK CODE BLOCK-----
>GCS d--(+) s: a-- C++++$ UBL++>++++ P+ L+ E W+++$ N+ o? K? w++++$>+++++$
>O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+)
>Dl++(++++) D++ G+ e>+++ h++(---) r++>+$ y++*>$ H++++ n---(----) p? !au w+
>v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
>------END GEEK CODE BLOCK------
>
>Home of Geek Code - http://www.geekcode.com/
>The Geek Code Decoder Page - http://www.ebb.org/ungeek//
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html




/\/\/\/\/\/\ Nothing is foolproof to a talented fool. /\/\/\/\/\/\

coreyfro@coreyfro.com
http://www.coreyfro.com/
http://stats.distributed.net/rc5-64/psearch.php3?st=coreyfro
ICQ : 3168059

-----BEGIN GEEK CODE BLOCK-----
GCS !d--(+) s: a- C++++$ UL++>++++ P+ L++>++++ E- W+++$ N++ o? K? w++++$>+++++$ O---- !M--- V- PS+++ PE++(--) Y+ PGP- t--- 5(+) !X- R(+) !tv b-(+) Dl++(++++) D++ G++(-) e>+++ h++(---) r++>+$ y++**>$ H++++ n---(----) p? !au w+ v- 3+>++ j- G'''' B--- u+++*** f* Quake++++>+++++$
------END GEEK CODE BLOCK------

Home of Geek Code - http://www.geekcode.com/
The Geek Code Decoder Page - http://www.ebb.org/ungeek//

