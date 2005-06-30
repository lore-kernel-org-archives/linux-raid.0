From: Sandro Dentella <sandro@e-den.it>
Subject: Re: Hung rebuilding
Date: Thu, 30 Jun 2005 17:38:16 +0200
Message-ID: <20050630153816.GA17341@casa.e-den.it>
References: <20050630134537.GA14145@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050630134537.GA14145@casa.e-den.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Following to the previous mail. I really need to recover the data in the
array. I didn't think it was sure to fsck during a stuck reconstruction so I
set faulty the disk that is probably faulty 

  mdadm /dev/md3 --fail   /dev/hda7 (devfs way really...)
  mdadm /dev/md3 --remove /dev/hda7 (devfs way really...)
  
  now I read 

srv-ornago:~# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
 (...)
md3 : active raid1 ide/host0/bus1/target0/lun0/part7[1]
      74340672 blocks [2/1] [_U]
      [>....................]  recovery =  0.0% (192/74340672) finish=328392.5min speed=0K/sec
unused devices: <none>

so it is marked _U but is still under recovery!!!

Is it safe to fsck now? (at least as w/ 1 single disk...)


TIA
sandro
*:-)


-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
