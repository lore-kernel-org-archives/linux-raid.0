From: AndyLiebman@aol.com
Subject: XFS RAID only writing half the time
Date: Tue, 25 Nov 2003 10:07:56 EST
Sender: linux-xfs-bounce@oss.sgi.com
Message-ID: <1e2.143843bf.2cf4ca4c@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-xfs-bounce@oss.sgi.com>
Errors-to: linux-xfs-bounce@oss.sgi.com
To: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

A puzzle. 

I am writing uncompressed video (18 MB/sec) to a RAID 5 array through a 
Gigabit network. I am using the xfs filesystem on the array with a block size of 
4096 and an internal log. The RAID has a chunk size of 128K. Otherwise, all 
settings are the default (i.e., left symetric algorithm). 

I have a P4-3.06 with 1 GB RAM. I have hyperthreading enabled -- and Mandrake 
9.2 (2.4.22 kernel) shows that I have 2 CPUs. 

While capturing video, I am running a monitoring program, XOSVIEW -- which 
shows usage of memory, cpu, ints (interrupts?), and disk read/write/idle 
activity. 

Although data is coming into my Linux machine at a rate of 18 MB/sec, I don't 
see any disk activity for as much as 30 or 40 seconds after I begin recording 
video. Looking at XOSVIEW, I can see on the memory display that the cache 
fills up until my memory is almost entirely full, and ONLY THEN does the disk 
writing activity begin. 

Usually this is fine, but once in a while -- after capturing video for 20 
minutes or so, the system will have a "hiccup" and fail to write data fast 
enough. My video editing application will then stop capturing. I don'

It seems to me that there must be a way to tell my system not to cache so 
much data before beginning to write so that there is more margin for delays. 

It also seems there should be a way to tell my system to spend more time 
writing to the RAID array. 

When I test out my RAID with Bonnie++, it looks as if sequential writes are 
about 30 MB/sec -- so the RAID itself is fast enough to keep up with the video. 
And so is the gigabit network. 

Does anybody have any ideas? 
