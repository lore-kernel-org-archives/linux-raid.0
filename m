From: Manish Awasthi <manish.awasthi@caviumnetworks.com>
Subject: md raid performance with 3-18-rc3
Date: Mon, 24 Nov 2014 13:40:06 +0530
Message-ID: <5472E7DE.5070702@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We benchmarked the md raid driver performance on 3-18-rc3 kernel and 
compared the results with that of 3.6.11. The reason for this exercise 
is to understand if multithreaded raid driver has any performance 
benefits over 3.6.11 which is single threaded. Here are some details 
about the setup

System: Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz 4 cores (8threads), 
8GB RAM.
Setup: 3 SSDs create a raid5 array
test tool: iozone (only read/re-read, write/re-write tested), blocksize: 
4k-64k, filesize: 1Gig to 200Gig

Comparison was done for speed of data transfer in kBytes/sec and also 
the CPU utilization as reported by iozone.

raid on 3.18.0-rc3 performed much worse than raid on 3.6.11.

Read/Write: raid on 3.18.0-rc3 operated at almost half the speed of raid 
on 3.6.11

CPU Utilization: With md raid on 3.18.0-rc3, the CPU utilization was 
less than half of md raid on 3.6.11 on WRITE operations. However, for 
READ operations, 3.18-0.rc3 had more CPU utilization than 3.6.11.

Also, I noticed that scaling up the CPU cores of the system scales down 
the raid througput with 3.18.0-rc3.

I do have detailed logs of the comparison but I'm not sure I should send 
those on this mailing list.

If my observation aligns with someone else's, then what is really the 
gain with multithreaded raid.

Manish
