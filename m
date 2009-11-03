From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: Setup for Performance
Date: Mon, 02 Nov 2009 19:00:06 -0500
Message-ID: <4AEF7286.6080509@gmail.com>
References: <4AEF579D.5040803@gmail.com> <4AEF6E91.3090902@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AEF6E91.3090902@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just quick searching around:

"Using a LSISAS 1068E I/O processor with Fusion-MPT (Message Passing
Technology) for optimum RAID performance and a PCI Express host
interface for increased bandwidth, these UIO internal RAID adapters
deliver an intelligent and robust RAID solution."

http://www.lsi.com/storage_home/products_home/standard_product_ics/sas_ics/lsisas1068e/index.html

I am not sure if iozone was used correctly here:

storrgie@ALEXANDRIA:/mnt/ARRAY$ iozone -s 4096
    Run began: Mon Nov  2 18:02:41 2009

    File size set to 4096 KB
    Command line used: iozone -s 4096
    Output is in Kbytes/sec
    Time Resolution = 0.000001 seconds.
    Processor cache size set to 1024 Kbytes.
    Processor cache line size set to 32 bytes.
    File stride size set to 17 * record size.
                                                            random 
random    bkwd   record   stride                                  
              KB  reclen   write rewrite    read    reread    read  
write    read  rewrite     read   fwrite frewrite   fread  freread
            4096       4  670491 1309061  2432098  2163764 2205712
1148325 2123381  1300736  2214241   647788  1131832 2419425  2079181

I did not set any of the file system settings when creating my array's
file system, I simply did a mkfs.ext4 on the device. This leads me to
believe that I lost some of the performance due to my laziness.


Richard Scobie wrote:
> Andrew Dunn wrote:
>
>> My original array was a raid6 of 9 WD caviar black drives, the chunk
>> size was 64k. I use USAS-AOC-L8i controllers to address all of my drives
>> and the TLER setting on the drives is enabled for 7 seconds.
>
>> I have noticed slow rebuilding time when I first created the array and
>> intermittent lockups while writing large data sets.
>
> Does the USAS-AOC-L8i use a Marvell controller?
>
> If so, someone was posting here recently that they have problems with
> it locking up under md RAID loads. Have a look over the past couple of
> months archives.
>
> Regards,
>
> Richard

-- 
Andrew Dunn
http://agdunn.net

