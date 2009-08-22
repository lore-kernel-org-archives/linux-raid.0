From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Help
Date: Sat, 22 Aug 2009 16:59:04 -0400
Message-ID: <B0F2EBD236974CA9878F0752EACFC835@m5>
References: <200908210627.06241.Info@quantum-sci.net> <4A902134.2020009@anonymous.org.uk> <200908221112.35952.Info@quantum-sci.net> <200908221345.00567.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908221345.00567.Info@quantum-sci.net>
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Info@quantum-sci.net
} Sent: Saturday, August 22, 2009 4:45 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: Help
} 
} On Saturday 22 August 2009 11:12:35 Info@quantum-sci.net wrote:
} > Goswin says, "For scanning your videos raid10 with far layout is
} probably best with
} > a large read ahead."  I have the RAID10 blocksize set to 1024 for the
} video partition, but any idea how to set readahead?
} 
} My gosh, it turns out this setting is astounding.  You test your drive
} speed with some large file, as such:
} # time dd if={somelarge}.iso of=/dev/null bs=256k
} 
} ... and check your drive's default readahead setting:
} # blockdev --getra /dev/sda
} 256
} 
} ... then test with various settings like 1024, 1536, 2048, 4096, 8192, and
} maybe 16384:
} # blockdev --setra 4096 /dev/sda
} 
} Here are the results for my laptop.  I can't test the HTPC with the array
} yet, as it's still syncing.
}    256	 40.4 MB/s
}  1024	123 MB/s
}  1536	2.7 GB/s
}  2048	2.4 GB/s
}  4096	2.4 GB/s
}  8192	2.4 GB/s
} 16384	2.5 GB/s
} 
} I suspect it's best to use the minimum readahead for the best speed (in my
} case 1536), for two reasons:
} - To save memory;
} - So there isn't such a performance impact when the blocks are not
} sequential.

The disk cache is being used.  You should reboot between each test, or use a
file much bigger than the amount of RAM you have.  Or use a different file
each time.

