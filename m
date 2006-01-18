From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: paralellism of device use in md
Date: Tue, 17 Jan 2006 16:23:15 -0800
Message-ID: <43CD8A73.90703@nsr500.net>
References: <20060117120927.GU7017@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060117120927.GU7017@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Andy Smith wrote:
 > ...
> For example, are *writes* to a 2 device RAID-0 approaching twice as
> fast as to a single device?  If not, are they any faster at all?
> Are reads from a 2 device RAID-1 twice as fast as from a single
> device?  If there are benefits, how quickly do they degrade to
> nothing as disks are added?
> 

Server development where I work uses a 3-way mirror for system bits but 
this would be a costly solution for any sort of real storage and/or write 
performance.

Here's the last chunk of a pair of 120GB WD SATA-I drives, SiI3112 chipset, 
sata_sil driver, 2.4.32 kernel.  A three or four way stripe should get 
proportionally more provided separate controller channels and of course, 
risk scales with performance.

[16:05] abit:~ > cat /proc/mdstat | head -7
Personalities : [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md14 : active raid0 sdb13[1] sda13[0]
       114575616 blocks 32k chunks

md13 : active raid1 sdb12[1] sda12[0]
       20113216 blocks [2/2] [UU]

[16:06] abit:~ > hdparm -tT /dev/{md14,sd{a,b}13,md13,sd{a,b}12}

/dev/md14:
  Timing buffer-cache reads:   1908 MB in  2.00 seconds = 954.00 MB/sec
  Timing buffered disk reads:  272 MB in  3.01 seconds =  90.37 MB/sec

/dev/sda13:
  Timing buffer-cache reads:   1904 MB in  2.00 seconds = 952.00 MB/sec
  Timing buffered disk reads:  156 MB in  3.01 seconds =  51.83 MB/sec

/dev/sdb13:
  Timing buffer-cache reads:   1912 MB in  2.00 seconds = 956.00 MB/sec
  Timing buffered disk reads:  136 MB in  3.00 seconds =  45.33 MB/sec

/dev/md13:
  Timing buffer-cache reads:   1876 MB in  2.00 seconds = 938.00 MB/sec
  Timing buffered disk reads:  164 MB in  3.00 seconds =  54.67 MB/sec

/dev/sda12:
  Timing buffer-cache reads:   1904 MB in  2.00 seconds = 952.00 MB/sec
  Timing buffered disk reads:  166 MB in  3.02 seconds =  54.97 MB/sec

/dev/sdb12:
  Timing buffer-cache reads:   1892 MB in  2.00 seconds = 946.00 MB/sec
  Timing buffered disk reads:  146 MB in  3.00 seconds =  48.67 MB/sec
[16:08] abit:~ >

-- 
  | for direct mail add "private_" in front of user name
