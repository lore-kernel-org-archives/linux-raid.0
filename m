From: Philip Molter <philip@corp.texas.net>
Subject: Software RAID & Filesystem Cache
Date: Thu, 05 Aug 2004 11:31:55 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411260FB.4080604@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What is the relationship to software RAID, filesystem caching, and I/O? 
  Here's why I ask:

I have a software application that uses RRD files to monitor numerous 
devices.  All told, we're talking about 21GB of RRD files, about 75% of 
which are being updated every 5 minutes.  Each RRD file is about 3MB in 
size, and updating an RRD file involves a lot of seeking, and writing 
small bits of data to very small parts.  The application should never be 
reading the entire file into memory.  On a properly running system, 
reads are done almost entirely out of filesystem cache on a 4GB box. 
Checking iostat, there is very little read util (<10KB/s over 5 minutes).

Now, I have a box with 12 37GB Raptor 10000RPM drives hooked up to a 
3ware 8500-12 controller.  In software RAID10 under kernel 2.4 (1024k 
chunks), the system works as expected.  Read load is light.  The box has 
plenty of I/O to spare (which it should; those drives are monsters).  In 
software RAID10 under kernel 2.6 (1024k chunks), read load is 
excessively heavy.  Each *drive* reports anywhere from 8-12MB/s (5 
minute average).  The RAID10 device itself reports 95-120MB/s (5 minute 
average).  There is no way the application is actually requesting to 
read that much data.  I trust the figures reported by iostat, though, 
because the application cannot keep up and the system feels excessively 
heavy.  In software RAID10 under kernel 2.6 (32k chunks), the read load 
is lighter, on the order of 1MB/s per disk and 10-12MB/s for the RAID10 
device.  If I convert the box to hardware RAID, the box functions 
normally.  Read levels are even better than 2.4 software RAID 
configuration (literally, less than 1KB/s over a 5 minute average). 
Each configuration is doing exactly the same work, with the exact same 
code and data.  The only difference is the kernel and software RAID 
configurations.

It's almost as if every read request to software RAID under 2.6 is 
bypassing the filesystem cache and furthermore, reading the entire 
chunk, not just the bit of information it needs (that's the only way I 
can explain the drop in read activity between 1024k and 32k).

Kernels are:
2.4.20-31.9 (roughtly 2.4.22)
2.6.7-1.494.2.2 (roughtly 2.6.8-rc2)

Filesystem is ext3

The RAIDs are setup as 6 RAID1 mirrors (2 drives each), striped together.

Any insight is greatly appreciated.
Philip
