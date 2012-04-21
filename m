From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: dmesg deluge: RAID1 conf printout
Date: Sat, 21 Apr 2012 15:55:15 +0200
Message-ID: <4F92BC43.3010603@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

Ever since I installed a 3.2 kernel on my Ubuntu  11.04 system, dmesg 
began being flooed with messages such as the following:

[15746.465106]  disk 1, wo:0, o:1, dev:sdb2
[15748.100302] RAID1 conf printout:
[15748.100306]  --- wd:2 rd:2
[15748.100310]  disk 0, wo:0, o:1, dev:sdd2
[15748.100313]  disk 1, wo:0, o:1, dev:sdb2
[15748.438638] RAID1 conf printout:
[15748.438642]  --- wd:2 rd:2
[15748.438646]  disk 0, wo:0, o:1, dev:sdd2
[15748.438649]  disk 1, wo:0, o:1, dev:sdb2
[15751.181020] RAID1 conf printout:
[15751.181026]  --- wd:2 rd:2
[15751.181030]  disk 0, wo:0, o:1, dev:sdd2
[15751.181034]  disk 1, wo:0, o:1, dev:sdb2
[15751.630244] RAID1 conf printout:
[15751.630250]  --- wd:2 rd:2
[15751.630255]  disk 0, wo:0, o:1, dev:sdd2
[15751.630259]  disk 1, wo:0, o:1, dev:sdb2
[15754.004658] RAID1 conf printout:
[15754.004662]  --- wd:2 rd:2
[15754.004666]  disk 0, wo:0, o:1, dev:sdd2
[15754.004670]  disk 1, wo:0, o:1, dev:sdb2
[15754.312749] RAID1 conf printout:
[15754.312754]  --- wd:2 rd:2
[15754.312758]  disk 0, wo:0, o:1, dev:sdd2
[15754.312762]  disk 1, wo:0, o:1, dev:sdb2
[15759.231107] RAID1 conf printout:
[15759.231112]  --- wd:2 rd:2
[15759.231115]  disk 0, wo:0, o:1, dev:sdd2
[15759.231118]  disk 1, wo:0, o:1, dev:sdb2

(etc, ad infinitum)

I'm now running a 3.3 kernel and it's still happening. My RAID sets are 
working just fine; it's just this nuisance log spamming that's annoying.

Anything I can do about that?

root@zotac:~# uname -a
Linux zotac 3.3.2-030302-generic #201204131335 SMP Fri Apr 13 17:36:17 
UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
root@zotac:~# mdadm -V
mdadm - v3.1.4 - 31st August 2010


Thanks, Jan
