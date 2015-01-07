From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Wed, 7 Jan 2015 08:34:01 -0500
Message-ID: <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl>
References: <54ABEE54.6020707@sympatico.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54ABEE54.6020707@sympatico.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just to give a small update (I realize many people may still be on holidays)

I've tried to work with a few people on IRC, and in conjunction with 
lots of reading from others' experiences attempting to recover the array 
but no luck yet.
I /hope/ I haven't ruined anything.

The forum post referenced below has full details, but here's a summary 
of "what happened"
notice how some drives are "moving" around :( [either due to a mistake I 
made, or the server haulting/lockup during rebuilds, I'm not sure]

{{{
-------------------------------------------------------------------------------------------
|                     |                Device Role #
-------------------------------------------------------------------------------------------
|  DEVICE  | COMMENTS | Dec GOOD | Jan4 6:28AM | 12:10PM | 12:40PM | 
Jan5 12:30AM | 12:50AM | 8:30AM | 6:34PM | Jan6 6:45AM |
-------------------------------------------------------------------------------------------
| /dev/sdi |          |    4     |      4      |    4    |    4    | 
   4       |    4    |    4   |    4   |      4      |
| /dev/sdj | failing  |    5     |   5 FAIL    |   ( )   |    8    | 
   8       |  8 FAIL |   ( )  |   ( )  |     ( )     |
| /dev/sdk | failing? |    0     |      0      |    0    |    0    | 
   0       |    0    |    0   | 0 FAIL |   0 FAIL    |
| /dev/sdl |          |    6     |      6      |    6    |    6    | 
   6       |    6    |    6   |    6   |      6      |
| /dev/sdm |          |    1     |      1      |    1    |    1    | 
  ( )      |   ( )   |   ( )  |    8   |   8 SPARE   |
| /dev/sdn |          |    2     |      2      |    2    |    2    | 
   2       |    2    |    2   |    2   |      2      |
| /dev/sdo |          |    3     |      3      |    3    |    3    | 
   3       |    3    |    3   |    3   |      3      |
| /dev/sdp |          |    7     |      7      |    7    |    7    | 
   7       |    7    |    7   |    7   |      7      |
-------------------------------------------------------------------------------------------
}}}

Full details from my e-mail notifications of /proc/mdstat (although 
unfortunately I don't have FULL mdadm --detail/examine information per 
state transition)
{{{
Dec GOOD
md2000 : active raid6 sdo1[3] sdj1[5] sdk1[0] sdi1[4] sdn1[2] sdm1[1] 
sdp1[7] sdl1[6]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/8] [UUUUUUUU]

FAIL EVENT on Jan 4th @ 6:28AM
md2000 : active raid6 sdo1[3] sdj1[5](F) sdk1[0] sdi1[4] sdn1[2] sdm1[1] 
sdp1[7] sdl1[6]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/7] [UUUU_UUU]
       [==============>......]  check = 73.6% (1439539228/1953513408) 
finish=536.6min speed=15960K/sec

DEGRADED EVENT on Jan 4th @ 6:39AM
md2000 : active raid6 sdo1[3] sdj1[5](F) sdk1[0] sdi1[4] sdn1[2] sdm1[1] 
sdp1[7] sdl1[6]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/7] [UUUU_UUU]
       [==============>......]  check = 73.6% (1439539228/1953513408) 
finish=5091.8min speed=1682K/sec

DEGRADED EVENT on Jan 4th @ 12:10PM
md2000 : active raid6 sdo1[3] sdn1[2] sdi1[4] sdm1[1] sdk1[0] sdp1[7] 
sdl1[6]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/7] [UUUU_UUU]

DEGRADED EVENT on Jan 4th @ 12:21PM
md2000 : active raid6 sdk1[0] sdo1[3] sdm1[1] sdn1[2] sdi1[4] sdp1[7] 
sdl1[6]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/7] [UUUU_UUU]

DEGRADED EVENT on Jan 4th  @ 12:40PM
md2000 : active raid6 sdj1[8] sdm1[1] sdo1[3] sdn1[2] sdk1[0] sdi1[4] 
sdp1[7] sdl1[6]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/7] [UUUU_UUU]
       [>....................]  recovery =  0.2% (5137892/1953513408) 
finish=921.7min speed=35227K/sec

DEGRADED EVENT on Jan 5th @ 12:30AM
md2000 : active raid6 sdk1[0] sdo1[3] sdn1[2] sdj1[8] sdi1[4] sdl1[6] 
sdp1[7]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/6] [U_UU_UUU]
       [============>........]  recovery = 62.9% (1229102028/1953513408) 
finish=259.8min speed=46466K/sec

FAIL SPARE EVENT on Jan 5th @ 12:50AM
md2000 : active raid6 sdk1[0] sdo1[3] sdn1[2] sdj1[8](F) sdi1[4] sdl1[6] 
sdp1[7]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/6] [U_UU_UUU]
       [=============>.......]  recovery = 68.1% (1332029020/1953513408) 
finish=150.3min speed=68897K/sec

DEGRADED EVENT on Jan 5th @ 6:43AM
md2000 : active raid6 sdk1[0] sdo1[3] sdn1[2] sdj1[8](F) sdi1[4] sdl1[6] 
sdp1[7]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/6] [U_UU_UUU]
       [=============>.......]  recovery = 68.1% (1332029020/1953513408) 
finish=76028.6min speed=136K/sec

TEST MESSAGE on Jan 5th @ 8:30AM
md2000 : active raid6 sdo1[3] sdi1[4] sdn1[2] sdk1[0] sdl1[6] sdp1[7]
       11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2 
[8/6] [U_UU_UUU]
}}}

I've tried mdadm --create --assume-clean for several combinations of the 
"device role # ordering", but so far none have exposed a usable ext4 
partition for /dev/md2000.

Was speaking with someone on IRC, and it's been shown that the data 
offset for the devices has changed over time in mdadm, so I need to 
recompile mdadm 3.3.x and attempt it that way.
I'll update when I get to trying that.

~Fermmy

-------- Original Message --------
From: Matt Callaghan <matt_callaghan@sympatico.ca>
Sent: Tue 06 Jan 2015 09:16:52 AM EST
To: linux-raid@vger.kernel.org
Cc:
Subject: mdadm RAID6 "active" with spares and failed disks; need help


> I think I'm in a really bad state. Could an expert w/ mdadm please
> help?

I have a RAID6 mdadm device, and it got really messed up with spares:
{{{
md2000 : active raid6 sdm1[8](S) sdo1[3] sdi1[4] sdn1[2] sdk1[0](F)
sdl1[6] sdp1[7]
        11721080448 blocks super 1.1 level 6, 64k chunk, algorithm 2
[8/5] [__UU_UUU]
}}}

And is now really broken (inactive)
{{{
md2000 : inactive sdn1[2](S) sdm1[8](S) sdl1[6](S) sdp1[7](S) sdi1[4](S)
sdo1[3](S) sdk1[0](S)
        13674593976 blocks super 1.1
}}}

I have a forum post going w/ full details
http://www.linuxquestions.org/questions/linux-server-73/mdadm-raid6-active-with-spares-and-failed-disks%3B-need-help-4175530127/



I /think/ I need to force re-assembly here, but I'd like some review
from the experts before proceeding.

Thank you in advance for your time,
~Matt/Fermulator

