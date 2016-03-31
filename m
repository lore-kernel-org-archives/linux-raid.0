From: Benjamin Meier <maillists@ferienwohnung-altenbeken.de>
Subject: Recovery after failed chunk size change
Date: Thu, 31 Mar 2016 21:33:38 +0200
Message-ID: <56FD7B92.1030102@ferienwohnung-altenbeken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I tried to do a chunk size change from 4096k to 64k on a 7-disk RAID6 
array. I am using Debian Jessie with kernel 3.16 and mdadm 3.3.2. After 
I initiated the change the process staled immediately. I could watch it 
in /proc/mdadm that there has not been any progress at all. The 
backup-file hasn't been touched for days now.

So I decided to backup all data from that device in case it isn't 
starting at next reboot. Accidentally the system was restarted before 
the backup was finished. And now the array is not assembling any more, 
even with the correct --backup-file. I get "mdadm: Failed to restore 
critical section for reshape, sorry.".

So the first question is: How can I access the data again? I think there 
is no damage at this time- I appended an output from --examine at the 
end of this message. All seven drives giving me the same output in all 
relevant topics. Especially "Chunk Size", "New Chunksize" and "Reshape 
pos'n" is all the same.
What is the best way now that I do not damage any data?

Second question: Is the problem with the level change a known bug?

Thanks for reading!

--
/dev/disk/by-partlabel/hyper_TA_1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x5
            Name : hyper:TA  (local to host hyper)
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 3434725376 (1637.80 GiB 1758.58 GB)
      Array Size : 8586813440 (8189.02 GiB 8792.90 GB)
     Data Offset : 147456 sectors
    Super Offset : 8 sectors
    Unused Space : before=147368 sectors, after=0 sectors
           State : clean

Internal Bitmap : 8 sectors from superblock
   Reshape pos'n : 0
   New Chunksize : 64K

     Update Time : Thu Mar 31 17:57:01 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : e7172c1f - correct
          Events : 527046

          Layout : left-symmetric
      Chunk Size : 4096K

    Device Role : Active device 5
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

