From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Sat, 20 Oct 2007 10:05:50 +0200
Message-ID: <4719B6DE.9040403@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	 <47181CB2.1060602@tmr.com>  <471864F8.9010209@systella.fr>	 <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>	 <4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr>	 <47191855.4020402@systella.fr>  <47191BCF.2000908@systella.fr> <1192828331.30976.26.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192828331.30976.26.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Dan Williams wrote:
> On Fri, 2007-10-19 at 14:04 -0700, BERTRAND Jo=C3=ABl wrote:
>>         Sorry for this last mail. I have found another mistake, but =
I
>> don't
>> know if this bug comes from iscsi-target or raid5 itself. iSCSI targ=
et
>> is disconnected because istd1 and md_d0_raid5 kernel threads use 100=
%
>> of
>> CPU each !
>>
>> Tasks: 235 total,   6 running, 227 sleeping,   0 stopped,   2 zombie
>> Cpu(s):  0.1%us, 12.5%sy,  0.0%ni, 87.4%id,  0.0%wa,  0.0%hi,  0.0%s=
i,
>> 0.0%st
>> Mem:   4139032k total,   218424k used,  3920608k free,    10136k
>> buffers
>> Swap:  7815536k total,        0k used,  7815536k free,    64808k
>> cached
>>
>>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAN=
D
>>
>>   5824 root      15  -5     0    0    0 R  100  0.0  10:34.25 istd1
>>
>>   5599 root      15  -5     0    0    0 R  100  0.0   7:25.43
>> md_d0_raid5

	When iSCSI works fine :

Tasks: 231 total,   2 running, 229 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.2%us,  2.5%sy,  0.0%ni, 95.7%id,  0.1%wa,  0.0%hi,  1.5%si,=20
0.0%st
Mem:   4139032k total,  4126064k used,    12968k free,    94680k buffer=
s
Swap:  7815536k total,        0k used,  7815536k free,  3758776k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND=20

  9774 root      15  -5     0    0    0 R   40  0.0   2:00.34 istd1=20

  9738 root      15  -5     0    0    0 S    9  0.0   2:06.56=20
md_d0_raid5
  4129 root      20   0 41648 5024 2432 S    6  0.1   2:46.39=20
fail2ban-server
  9830 root      20   0  3248 1544 1120 R    1  0.0   0:00.18 top=20

  4063 root      20   0  7424 5288  832 S    1  0.1   0:00.84 unfsd=20

  9776 root      15  -5     0    0    0 D    1  0.0   0:00.82 istiod1=20

  9780 root      15  -5     0    0    0 D    1  0.0   0:00.96 istiod1=20

  9782 root      15  -5     0    0    0 D    1  0.0   0:01.10 istiod1=20

     1 root      20   0  2576  960  816 S    0  0.0   0:01.56 init=20

     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd=20

     3 root      RT  -5     0    0    0 S    0  0.0   0:00.00=20
migration/0

After a random time (iSCSI target is not disconnected but doesn't answe=
r=20
to initiator requests):

Tasks: 232 total,   5 running, 226 sleeping,   0 stopped,   1 zombie
Cpu(s):  0.1%us,  7.9%sy,  0.0%ni, 91.6%id,  0.0%wa,  0.1%hi,  0.2%si,=20
0.0%st
Mem:   4139032k total,  4125912k used,    13120k free,    95640k buffer=
s
Swap:  7815536k total,        0k used,  7815536k free,  3758792k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND=20

  9738 root      15  -5     0    0    0 R  100  0.0   3:56.57=20
md_d0_raid5
  9739 root      15  -5     0    0    0 D   14  0.0   0:20.34=20
md_d0_resync
  9845 root      20   0  3248 1544 1120 R    1  0.0   0:07.00 top=20

  4129 root      20   0 41648 5024 2432 S    0  0.1   2:55.94=20
fail2ban-server
     1 root      20   0  2576  960  816 S    0  0.0   0:01.58 init=20

     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd=20

     3 root      RT  -5     0    0    0 S    0  0.0   0:00.00=20
migration/0
     4 root      15  -5     0    0    0 S    0  0.0   0:00.02=20
ksoftirqd/0
     5 root      RT  -5     0    0    0 S    0  0.0   0:00.00=20
migration/1
     6 root      15  -5     0    0    0 S    0  0.0   0:00.00=20
ksoftirqd/1

	You can see a very strange thing... When I have booted this server,=20
md0_d0 was clean. When bug occurs, md_d0_resync is started (/dev/md/d0p=
1=20
is a part of my raid1 array). Why ? This partition is not mounted on=20
local server, only exported by iSCSI.

After disconnection of iSCSI target :

Tasks: 232 total,   7 running, 224 sleeping,   0 stopped,   1 zombie
Cpu(s):  0.0%us, 15.2%sy,  0.0%ni, 84.3%id,  0.0%wa,  0.1%hi,  0.3%si,=20
0.0%st
Mem:   4139032k total,  4127584k used,    11448k free,    95752k buffer=
s
Swap:  7815536k total,        0k used,  7815536k free,  3758792k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND=20

  9738 root      15  -5     0    0    0 R  100  0.0   4:56.82=20
md_d0_raid5
  9774 root      15  -5     0    0    0 R  100  0.0   5:52.41 istd1=20

  9739 root      15  -5     0    0    0 R   14  0.0   0:28.90=20
md_d0_resync
  9916 root      20   0  3248 1544 1120 R    2  0.0   0:00.56 top=20

  4129 root      20   0 41648 5024 2432 S    0  0.1   2:56.17=20
fail2ban-server
     1 root      20   0  2576  960  816 S    0  0.0   0:01.58 init=20

     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd=20

     3 root      RT  -5     0    0    0 S    0  0.0   0:00.00=20
migration/0
     4 root      15  -5     0    0    0 S    0  0.0   0:00.02=20
ksoftirqd/0
     5 root      RT  -5     0    0    0 S    0  0.0   0:00.00=20
migration/1
     6 root      15  -5     0    0    0 S    0  0.0   0:00.00=20
ksoftirqd/1

> What is the output of:
> cat /proc/5824/wchan
> cat /proc/5599/wchan

Root poulenc:[/usr/scripts] > cat /proc/9738/wchan
_startRoot poulenc:[/usr/scripts] > cat /proc/9774/wchan
_startRoot poulenc:[/usr/scripts] > vmstat -a
procs -----------memory---------- ---swap-- -----io---- -system--=20
----cpu----
  r  b   swpd   free  inact active   si   so    bi    bo   in   cs us s=
y=20
id wa
  5  0      0  10824 3777528 112280    0    0     7    19   12   19  0=20
0 100  0
Root poulenc:[/usr/scripts] > vmstat
procs -----------memory---------- ---swap-- -----io---- -system--=20
----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us s=
y=20
id wa
  5  0      0  10928  95856 3756880    0    0     7    19   12   19  0=20
0 100  0
Root poulenc:[/usr/scripts] >  vmstat -s
       4139032 K total memory
       4127864 K used memory
        112216 K active memory
       3777568 K inactive memory
         11168 K free memory
         95928 K buffer memory
       3756896 K swap cache
       7815536 K total swap
             0 K used swap
       7815536 K free swap
         26901 non-nice user cpu ticks
           824 nice user cpu ticks
        204746 system cpu ticks
      94245668 idle cpu ticks
         14378 IO-wait cpu ticks
          3086 IRQ cpu ticks
         33971 softirq cpu ticks
             0 stolen cpu ticks
       6555730 pages paged in
      18136571 pages paged out
             0 pages swapped in
             0 pages swapped out
      11259263 interrupts
      18167358 CPU context switches
    1192827483 boot time
          9962 forks
Root poulenc:[/usr/scripts] > vmstat -d
disk- ------------reads------------ ------------writes-----------=20
-----IO------
        total merged sectors      ms  total merged sectors      ms=20
cur    sec
sda   716720 143247 94849012 2617628   6732  24789  269070  222236=20
0    532
sdb   103590  23780 6140736   85244 409226 308936 88160014 13352564=20
  0    929
md0    17469      0  456250       0   4557      0   36456       0      =
0=20
      0
sdc   265108 2103743 37883308 2810656 266586 272237 8767696  628236=20
  0    825
sdd   266248 2099943 37844236 2801400 264081 275321 8781088  609140=20
  0    824
sde   263660 2104487 37875132 2835548 262296 276561 8776000  595140=20
  0    826
sdf   283262 2084095 37862108 2432988 262197 277305 8785600  581008=20
  0    779
sdg   285205 2082611 37870324 2291464 260836 278822 8791456  567908=20
  0    752
sdh   291773 2072874 37817788 1892320 260572 278182 8775472  550688=20
  0    685
loop0      0      0       0       0      0      0       0       0      =
0=20
      0
loop1      0      0       0       0      0      0       0       0      =
0=20
      0
loop2      0      0       0       0      0      0       0       0      =
0=20
      0
loop3      0      0       0       0      0      0       0       0      =
0=20
      0
loop4      0      0       0       0      0      0       0       0      =
0=20
      0
loop5      0      0       0       0      0      0       0       0      =
0=20
      0
loop6      0      0       0       0      0      0       0       0      =
0=20
      0
loop7      0      0       0       0      0      0       0       0      =
0=20
      0
md6       31      0     496       0      0      0       0       0      =
0=20
      0
md1     4326      0  161366       0     27      0     110       0      =
0=20
      0
md2   206279      0 4713706       0  14670      0  118752       0      =
0=20
      0
md3     6709      0  392442       0   9964      0   80040       0      =
0=20
      0
disk- ------------reads------------ ------------writes-----------=20
-----IO------
        total merged sectors      ms  total merged sectors      ms=20
cur    sec
md4      247      0    3746       0    131      0    1208       0      =
0=20
      0
md5    63245      0 7365546       0    292      0    2424       0      =
0=20
      0
md_d0     14      0     216       0 642029      0 36004104       0=20
0      0
Root poulenc:[/usr/scripts] >

	Please note that zombies process are not signifiant for this server. I=
t=20
runs watchdog and zombies process counter is allways between 0 and 2.

	When iSCSI target hangs, load average is :
load average: 14.03, 13.63, 10.47 with only md_d0_raid5, istd1 and=20
md_d0_resync running process.

  9774 root      15  -5     0    0    0 R  100  0.0  18:17.63 istd1=20

  9738 root      15  -5     0    0    0 R  100  0.0  17:22.04=20
md_d0_raid5
  9739 root      15  -5     0    0    0 R   14  0.0   2:15.18=20
md_d0_resync

	I won't reboot this server if you need some other information.

	Regards,

	JKB
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
