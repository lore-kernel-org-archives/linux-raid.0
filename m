From: Antonello Piemonte <ap@cyberlab.de>
Subject: Re: raid 1 vs raid 0+1
Date: Tue, 29 Oct 2002 16:27:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210291527.g9TFRl018162@gg.cyberlab.de>
References: <200210291229.g9TCTcO05488@gg.cyberlab.de> <20021029131453.GB24171@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021029131453.GB24171@unthought.net>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 29 October 2002 14:14, Jakob Oestergaard wrote:
> On a dual PIII-550 with 512 MB of memory, ext3, and a RAID-0+1 (four 40G
> 7200rpm IBM IDE Deathstar disks, 64k chunk-size on the RAID-0), I get:
>
> $ time for i in {0,1,2,3,4,5,6,7,8,9}; do mkdir $i; for j in
> {0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}; do dd if=/dev/zero of=$j/$i
> bs=1k count=4; done done
>
> real    0m5.024s
>
> So, 5 seconds for writing one thousand 4 kb files *sequentially*.
>
> Note that I only put 100 files in each directory - if I put 1000 files
> in one directory, performance would degrade (more significantly when the
> number is, say, 10000).

Dear Jakob,

for a start I have set my "baseline" measurement: using a 10000 rpm IBM 
Ultrastar with Adaptec 29160 Ultra160 SCSI adapter
with 512Mb RAM and PIII-800 I can create 1000 4kb files
in one directory (this case is what is going to happen in the real
application) in abou 8secs using this:
--
#!/bin/sh

i=1
while [ $i -le 1000 ]
do
        echo $i
        dd if=/dev/zero of=file_$i bs=1k count=4
        i=`expr $i + 1`
done
exit 0
--

$ time sh write.sh
...
 real    0m8.388s
user    0m4.037s
sys     0m3.834s

writing 10.000 files gives instead
$ time sh write.sh
real    1m46.499s
user    0m40.096s
sys     1m0.400s

so a 10-folds increase of number of files gives about
a 12-fold increase in "real" time ... 
I will play next with journaling mode (using data=ordered now)
and post outcome here: thanks for your comments so far !
antonello
