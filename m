From: George Shuklin <george.shuklin@gmail.com>
Subject: md/raid10 deadlock at 'Failing raid device'
Date: Thu, 10 May 2012 06:47:27 +0400
Message-ID: <4FAB2C3F.3070105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>, Jonathan Nieder <jrnieder@gmail.com>
List-Id: linux-raid.ids

As Jonathan Nieder proposed, writing here about new deadlock bug I met 
recently with raid10.

Summary: under some condition multiple simultaneously failing devices 
cause with some chance deadlock on operations with failed array.

Conditions:
3 Adadptec raid controllers (Adaptec Device 028, aacraid). Every one do 
have 8 directly attached SATA disks   (without extenders or expanders). 
Those disks are configured as 'JBOD' and passed to linux almost 'as is'. 
Those disks joined in three raid10 arrays (by using linux raid). Those 
three arrays joined in raid0.

Configuration looks like this:

   3 x RAID10
md101 [UUUUUUUU] --\
md102 [UUUUUUUU] ------ md100 [UUU]  (raid0)
md103 [UUUUUUUU] --/

After that all disks are deconfigured from adaptec utility. They 
dissappear from /dev/, but /proc/mdadm shows arrays fine.  After that 
some io performed on raid0. That, of cause, causing failure on all raid 
arrays and return IO error to calling software (in my case it was 'fio' 
disk performance test utility).

Two arrays fails gracefully, but one did not. It stuck with one disk 
(which one was not in system) and did not return anything to calling 
software, like it was in raid10 deadlock, which was fixed in commit d9b42d.

Content /proc/mdstat after failure:

md100 : active raid0 md103[2] md102[1] md101[0]
  11714540544 blocks super 1.2 256k chunks

md101 : active raid10 sdv[7](W)(F) sdu[6](W)(F) sdo[5](W)(F) sdn[4](W)(F) sdm[3](W)(F) sdg[2](W)(F) sdf[1](W)(F) sde[0](W)(F)
  3904847872 blocks super 1.2 256K chunks 2 near-copies [8/0] [________]
  bitmap: 0/466 pages [0KB], 4096KB chunk, file: /var/mdadm/md101

md103 : active raid10 sdr[0](W)(F) sdab[7](W)(F) sdt[6](W)(F) sdl[5](W)(F) sdaa[4](W) sds[3](W)(F) sdk[2](W)(F) sdz[1](W)(F)
  3904847872 blocks super 1.2 256K chunks 2 near-copies [8/1] [____U___]
  bitmap: 1/466 pages [4KB], 4096KB chunk, file: /var/mdadm/md103

md102 : active raid10 sdw[0](W)(F) sdj[7](W)(F) sdy[6](W)(F) sdq[5](W)(F) sdi[4](W)(F) sdx[3](W)(F) sdp[2](W)(F) sdh[1](W)(F)
  3904847872 blocks super 1.2 256K chunks 2 near-copies [8/0] [________]

I recheck - /dev/sdaa was no longer in system, but raid10 has think it was.

In dmesg those messages repeat very fast:

[4474.074462] md/raid10:md103: sdaa: Failing raid device

It was so fast so I got race between logging to ring buffer and syslog activity and got this in /var/log/messages:
May 5 21:20:04 server kernel: [ 4507.578517] md/raid10:md103: sdaa: Faid device
May 5 21:20:04 server kernel: [ 4507.578525] md/raid10:md103: sdaa: Faaid device
May 5 21:20:04 server kernel: [ 4507.578533] md/raid10:md103: sdaa: aid device
May 5 21:20:04 server kernel: [ 4507.578541] md/raid10:md103: sdaa: Faid devic
May 5 21:20:04 server kernel: [ 4507.578549] md/raid10:md103: sdaa: Faid device
May 5 21:20:04 server kernel: [ 4507.578557] md/raid10:md103: sdaa: Faid device
May 5 21:20:04 server kernel: [ 4507.578566] md/raid10:md103: sdaa: Failaid device


It was with linux 3.2.0-2-amd64


---
wBR, George Shuklin
