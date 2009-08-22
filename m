From: Info@quantum-sci.net
Subject: Re: Help
Date: Sat, 22 Aug 2009 13:45:00 -0700
Message-ID: <200908221345.00567.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <4A902134.2020009@anonymous.org.uk> <200908221112.35952.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908221112.35952.Info@quantum-sci.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 22 August 2009 11:12:35 Info@quantum-sci.net wrote:
> Goswin says, "For scanning your videos raid10 with far layout is probably best with
> a large read ahead."  I have the RAID10 blocksize set to 1024 for the video partition, but any idea how to set readahead?

My gosh, it turns out this setting is astounding.  You test your drive speed with some large file, as such:
# time dd if={somelarge}.iso of=/dev/null bs=256k

... and check your drive's default readahead setting:
# blockdev --getra /dev/sda
256

... then test with various settings like 1024, 1536, 2048, 4096, 8192, and maybe 16384:
# blockdev --setra 4096 /dev/sda

Here are the results for my laptop.  I can't test the HTPC with the array yet, as it's still syncing.
   256	 40.4 MB/s
 1024	123 MB/s
 1536	2.7 GB/s
 2048	2.4 GB/s
 4096	2.4 GB/s
 8192	2.4 GB/s
16384	2.5 GB/s

I suspect it's best to use the minimum readahead for the best speed (in my case 1536), for two reasons:
- To save memory;
- So there isn't such a performance impact when the blocks are not sequential.

