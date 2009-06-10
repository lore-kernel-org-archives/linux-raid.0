From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Software RAID5 write issues
Date: Wed, 10 Jun 2009 20:30:53 +0100
Message-ID: <4A3009ED.1030408@anonymous.org.uk>
References: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2009 18:17, Steven Haigh wrote:
> After a week and a bit of googling, experimenting and frustration I'm 
> posting here and hoping I can get some clues on what could be wrong with 
> my 5 disk RAID5 SATA array.
> 
> The array in question is:
> md1 : active raid5 sdg1[0] sdf1[1] sde1[3] sdd1[2] sdc1[4]
>       1172131840 blocks level 5, 1024k chunk, algorithm 2 [5/5] [UUUUU]
> 
> All 5 drives are connection to a sil_sata controller (a 3112 & a 3114) 
> set up as a simple SATA controller (ie no RAID here).
> 
> Once the system buffer is full, write speeds to the array are usually 
> under 20MB/sec.
> 
> I am currently running CentOS 5.3 (kernel 2.6.18-128.1.10.el5.centos.plus).
> 
> I have lodged a bug report against RHEL 5.3, as I believe something is 
> not quite right here, but haven't been able to narrow down the exact issue.
>     https://bugzilla.redhat.com/show_bug.cgi?id=502499
> 
> Using bonnie++ to benchmark the array, it shows sequential block reads 
> at 90MB/sec but writes at 11MB/sec across the RAID5 array - a difference 
> I really didn't expect.
> 
> Any pointers on how to try to tackle this one and figure out the root 
> cause of the problem would be VERY helpful!

Do your drives rattle furiously while writing? Do you have a write 
intent bitmap? I found my write performance quite sucky until changing 
the bitmap settings, see 
http://marc.info/?l=linux-raid&m=124027469610660&w=2 for the thread. In 
short, changing the bitmap from its default 2M chunk size to 32M got me 
a substantial speed-up; here's my bonnie++ output on a 3-drive RAID-5:

# bonnie++ -d /mnt/store/bonnie/ -u john -n 256 -m beast
Using uid:500, gid:500.
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
beast            4G 72011  79 59334  10 35775   4 66455  64 174049   6 
215.8   0
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                 256 61524  81 377753  96 22143  28 53153  73 425291  99 
  8327  11
beast,4G,72011,79,59334,10,35775,4,66455,64,174049,6,215.8,0,256,61524,81,377753,96,22143,28,53153,73,425291,99,8327,11


Cheers,

John.

