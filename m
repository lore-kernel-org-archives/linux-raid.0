From: <c4c3m@oke.net.id>
Subject: RAID 5 On Linux
Date: Fri, 25 Jul 2003 07:54:59 +0700 (JAVT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <33208.202.73.109.166.1059094499.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear All,

Let me introduce my self, my name is Hendri, i'm application
administrator at
www.6221.net.I find your email from the source code, i try to solve my
self but
it seems i must contact you personally to ask your help about my
problem.That
Problem are :I had installed RH 6.2 on IBM Netfinity 5100, it seems ok
for 1
year till today, the partition  doesn't Work, i have 6 partition that
doesnt
alive.4 partition contain about Oracle Data, and 3 2 more is /usr
partition(From
Now On, i think its a very Bad Idea to locate RAID 5 to /usr :(( )then i
discovered /dev/md1 - /dev/md6 won't work, and the error message on
/proc/mdstat
wont show up.i can "reconfigure" at all, what should i do for saving
all those
data, because i dont have any backup
the md modules already loaded, because some partition, for example md0
is up and
can be mounted as /, and /proc/mdstat show some information that inform
any
partition that already sucess to load, such as / -> md0, /home -> md9
beside
that, mdx partition doesnt show any information.
Could i recover that partition
(which doesnt alive?)?

Created md5
md : superblock update time inconsistency -- using the most recent one
md : kicking non - fresh sdc10 from array !
md : kicking non - fresh sdc10 from array !
md : md5 : raid array is not clean -- Starting background reconstruction
md5 : max total readhead window set to 512k
raid 5 : not enough operational devices for md5 (2/3 failed)
raid 5 : failed to run raid set md5
do_md_run() returned -22
md5 stopped

/proc/mdstat

Personalities : [raid1][raid5] read_ahead 1024 sectors
md0 : active raid1 sdb1p0[ sda[1] 1566208 blocks [2/2][UU]
md9 : active raid5 sdc4[2] sdc3[1] sdc1[0] 995140 blocks level 5, 64k
chunk,
algorithm 0[3/3][UUU]
md2 : active raid5 sdc7[2] sda7[1] 1043968 blocks level 5, 64 k chunk,
algorithm
0[3/2][_UU]
md7 : active raid5 sdc12[2] sdb12[0] sda12[1] 819072 blocks level 5,
64k chunk,
algorithm 0[3/3][UUU]
md8 : active raid5 sdc13[2] sdb13[0] sda13[1] 1268864 blocks level 5,
64k chunk,
algorithm 0[3/3] [UUU]
unused devices : <none>/2][_UU]] [UUU]e raid5 sdc12[2] sdb12[0]
sda12[1] 819072
blocks c13[2] sdb13[0] sda13[1] 1268864 blocks level 5, 64k chunk,
algorithm
0[3/3] [UUU]e raid5 sdc12[2] sdb12[0] sda12[1] 819072 blocks level 5,
64k chunk,
0[3/2][_UU]

but in my /etc/fstab contain :
/dev/md0 until /dev/md9
so in /proc/mdstat doesnt apear beside md0, md9, md2, md7 and md8

When i look at the source
#define OUT_OF_DATE KERN_ERR \
"md: superblock update time inconsistency -- using the most recent
one\n"
md : kicking non - fresh sdc10 from array !
md : kicking non - fresh sdc10 from array !
menunjukkan ke source
if (ev1 < ev2) {
printk(KERN_WARNING "md: kicking non-fresh %s from
array!\n",
partition_name(rdev->dev));
kick_rdev_from_array(rdev);
continue;
}

Thanks for the attention




-----------------------------------------
This email was sent using OkeMail.
 "Your Communication LifeStyle!"
      http://www.oke.net.id/


