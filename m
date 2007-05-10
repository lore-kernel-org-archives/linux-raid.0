From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
Date: Thu, 10 May 2007 16:12:11 +0200
Message-ID: <4643283B.2060203@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762332AbXEJONv@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, rshitrit@marvell.com, dan.j.williams@intel.com, nickpiggin@yahoo.com.au, Justin Piszcz <jpiszcz@lucidpixels.com>, ilmari@ilmari.org
List-Id: linux-raid.ids

Ronen Shitrit wrote:

> The resync numbers you sent, looks very promising :)
> Do you have any performance numbers that you can share for these set of
> patches, which shows the Rd/Wr IO bandwidth.

I have some simple tests made with hdparm, with the results I don't 
understand.

We see hdparm results are fine if we access the whole device:

thecus:~# hdparm -Tt /dev/sdd

/dev/sdd:
  Timing cached reads:   392 MB in  2.00 seconds = 195.71 MB/sec
  Timing buffered disk reads:  146 MB in  3.01 seconds =  48.47 MB/sec


But are 10 times worse (Timing buffered disk reads) when we access 
partitions:

thecus:/# hdparm -Tt /dev/sdc1 /dev/sdd1

/dev/sdc1:
  Timing cached reads:   396 MB in  2.01 seconds = 197.18 MB/sec
  Timing buffered disk reads:   16 MB in  3.32 seconds =   4.83 MB/sec

/dev/sdd1:
  Timing cached reads:   394 MB in  2.00 seconds = 196.89 MB/sec
  Timing buffered disk reads:   16 MB in  3.13 seconds =   5.11 MB/sec


Why is it so much worse?


I used 2.6.21-iop1 patches from http://sf.net/projects/xscaleiop; right 
now I use 2.6.17-iop1, for which the results are ~35 MB/s when accessing 
a device (/dev/sdd) or a partition (/dev/sdd1).


In kernel config, I enabled Intel DMA engines.

The device I use is Thecus n4100, it is "Platform: IQ31244 (XScale)", 
and has 600 MHz CPU.


-- 
Tomasz Chmielewski
http://wpkg.org
