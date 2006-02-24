From: Brian Kelly <bkelly@unidata.ucar.edu>
Subject: Re: Help Please!  mdadm hangs when using nbd or gnbd
Date: Fri, 24 Feb 2006 16:48:53 -0700
Message-ID: <43FF9B65.5060703@unidata.ucar.edu>
References: <43FD00F4.3080308@unidata.ucar.edu> <022901c638b8$d85ed7b0$1600a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <022901c638b8$d85ed7b0$1600a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: JaniD++ <djani22@dynamicweb.hu>
List-Id: linux-raid.ids

Hi JaniD++, thank you very much for your reply.

I downloaded, patched, compiled and installed the 2.6.16-rc4 version of 
the kernel and installed it on the system where mdadm rebuilds quickly 
stop.  It made no difference and the rebuild stoped in the same place.

Yes, this server is a dual processor x86_64 system running two AMD 
Opteron 242 processors.  The mdadm rebuild hangs regardless of using the 
standard or smp kernels.

I have duplicated the problem with devices totalling less than 2TB but I 
have not tried it with an argument to nbd-server.  Let me do that now:

Last login: Fri Feb 24 13:49:38 2006 from leadstor.unidata.ucar.edu
[root@leadstor1 ~]# uname -a
Linux leadstor1.unidata.ucar.edu 2.6.14-1.1653_FC4 #1 Tue Dec 13 
21:34:16 EST 2005 x86_64 x86_64 x86_64 GNU/Linux
[root@leadstor1 ~]# modprobe nbd
[root@leadstor1 ~]# cd /dev
[root@leadstor1 dev]# ./MAKEDEV md
[root@leadstor1 dev]# ./MAKEDEV nb
[root@leadstor1 dev]# cd /opt/nbd-2.8.3
[root@leadstor1 nbd-2.8.3]# ./nbd-client leadstor5 2002 /dev/nb5
Negotiation: ..size = 2047KB
bs=1024, sz=2047
[root@leadstor1 nbd-2.8.3]# ./nbd-client leadstor6 2002 /dev/nb6
Negotiation: ..size = 2047KB
bs=1024, sz=2047
[root@leadstor1 nbd-2.8.3]# fdisk -l /dev/nb5

Disk /dev/nb5: 2 MB, 2096128 bytes
255 heads, 63 sectors/track, 0 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/nb5 doesn't contain a valid partition table
[root@leadstor1 nbd-2.8.3]# fdisk -l /dev/nb6

Disk /dev/nb6: 2 MB, 2096128 bytes
255 heads, 63 sectors/track, 0 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/nb6 doesn't contain a valid partition table

 >>> Hmm, 2 MB drives?  The nbd-server argument must be in bytes.  Well, 
let's see if it builds.

[root@leadstor1 nbd-2.8.3]# mdadm --create /dev/md2 -l 1 -n 2 /dev/nb5 
/dev/nb6
mdadm: array /dev/md2 started.
[root@leadstor1 nbd-2.8.3]# date
Fri Feb 24 14:31:54 MST 2006
[root@leadstor1 nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      1920 blocks [2/2] [UU]

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

 >>> Okay, that worked, but all the resyncs go a short way before 
quitting.  Let me expand the drives to 2GB and try again.

[root@leadstor1 nbd-2.8.3]# ./nbd-client leadstor5 2002 /dev/nb5
Negotiation: ..size = 2047851KB
bs=1024, sz=2047851
[root@leadstor1 nbd-2.8.3]# ./nbd-client leadstor6 2002 /dev/nb6
Negotiation: ..size = 2047851KB
bs=1024, sz=2047851
[root@leadstor1 nbd-2.8.3]# mdadm --create /dev/md2 -l 1 -n 2 /dev/nb5 
/dev/nb6 mdadm: array /dev/md2 started.
[root@leadstor1 nbd-2.8.3]# date
Fri Feb 24 14:50:10 MST 2006
[root@leadstor1 nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      2047744 blocks [2/2] [UU]
      [==>..................]  resync = 13.1% (268480/2047744) 
finish=0.4min speed=67120K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>
[root@leadstor1 nbd-2.8.3]# date
Fri Feb 24 14:50:24 MST 2006
[root@leadstor1 nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      2047744 blocks [2/2] [UU]
      [=========>...........]  resync = 46.8% (958656/2047744) 
finish=0.2min speed=63910K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>
[root@leadstor1 nbd-2.8.3]# date
Fri Feb 24 14:50:45 MST 2006
[root@leadstor1 nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      2047744 blocks [2/2] [UU]

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

 >>> Hmm, that worked too.  Okay, let me do more testing...

Okay, I'm back.  A 2,000,000 MB devices stops syncing immediately but a 
1,000,000 MB devices gets 10% of the way before it hangs.  I don't have 
time for more testing tonight, but this does appear to be a size issue 
after all.  What confuses me is that smaller volumes seem to have the 
same problem, but work for a longer period before failing.  More testing 
might show if it happens at the same point each time or if it varies 
like a race condition.  I could also see if I can duplicate the problem 
with dd, as you suggested.

So it seems NBDs may not be able to handle LBDs.  Can anyone confirm if 
this is the case?  Would any other tests help pinpoint the cause of my 
problem?

Thanks again for any help.

Brian


JaniD++ wrote:

>
>Hello,
>
>I have use a similar system, and i have some ideas:
>
>The general nbd deadlock is fixed on 2.6.16 series!
>
>The head node is X86_64 system, or 32 bit?
>Please try this system with 1.99TB nbd devices, and let me know, it is
>works?
>(I use my system like this: nbd-server 1230 /dev/md0 2097000 )
>
>Check this if the sync is stoped:
>
>1.
>ps fax | grep nbd-client
>
>2.
>dd if=/dev/nbX of=/dev/null bs=1M count=1 (or more)
>And dmesg messages after dd!
>
>3. make sure about network package lost.
>
>Cheers,
>Janos
>
>
>  
>
