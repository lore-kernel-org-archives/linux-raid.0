From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 12:40:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400D05AC.4030409@upfrontsystems.co.za>
References: <400CD0BF.2010808@upfrontsystems.co.za>	<16396.53737.911347.812076@notabene.cse.unsw.edu.au>	<400CE215.2050502@upfrontsystems.co.za> <16396.64514.820157.677722@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16396.64514.820157.677722@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

thank you very much for your help ..

>  mdadm -C /dev/md0 -l 5 -n 3 /dev/hda3 missing /dev/hdc3

Did that, once with 'missing' in each place. All I get:

cdimage root # mdadm --create /dev/md0 --raid-devices=3 --level=5 
--spare-devices=0 --chunk=64 missing /dev/hdb3 /dev/hdc3
mdadm: /dev/hdb3 appears to be part of a raid array:
     level=5 devices=3 ctime=Tue Jan 20 10:35:45 2004
mdadm: /dev/hdc3 appears to be part of a raid array:
     level=5 devices=3 ctime=Tue Jan 20 10:09:43 2004
Continue creating array? y
mdadm: array /dev/md0 started.
cdimage root # mount -r -t reiserfs /dev/md0 /mnt/gentoo/raid/
mount: Not a directory

cdimage root # cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 ide/host0/bus1/target0/lun0/part3[2] 
ide/host0/bus0/target1/lun0/part3[1]
       76003328 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]

unused devices: <none>


-- 
Jean Jordaan
http://www.upfrontsystems.co.za

