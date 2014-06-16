From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Mon, 16 Jun 2014 20:20:24 +0200
Message-ID: <1153494452.20140616202024@oudeis.org>
References: <1896515726.20140614235853@oudeis.org>
 <1454723160.20140615203503@oudeis.org> <539E5A90.3080207@turmel.org>
 <19411862.20140616155327@oudeis.org> <539F00AE.9090504@turmel.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539F00AE.9090504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi,

>> [root@gateway home]# lsof | grep md1
>> md1_raid1   461      root  cwd       DIR                9,0     4096          2 /
>> md1_raid1   461      root  rtd       DIR                9,0     4096          2 /
>> md1_raid1   461      root  txt   unknown                                        /proc/461/exe

PT> What is running as process ID 461?  That needs to be killed off, and any
PT> mount involving /dev/md1 stopped.
process ID 461 is [md_raid1] and can't be killed via kill or kill -9:
root       461  2.2  0.0      0     0 ?        S<   Jun14  61:09 [md1_raid1]

there is no "normal" mount on /dev/md1, maybe LVM has its fingers on
it although it should not?

[root@gateway ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              7.8G  4.8G  2.7G  65% /
/dev/mapper/vg_gateway-lv_var
                       12G  1.1G   11G   9% /var
/dev/mapper/vg_gateway-lv_home
                       12G  4.1G  7.2G  37% /home
/dev/mapper/vg_gateway-lv_data
                       60G   42G   15G  74% /data
tmpfs                 989M     0  989M   0% /dev/shm
[root@gateway ~]# umount /dev/md1
umount: /dev/md1: not mounted

tnx & cu

