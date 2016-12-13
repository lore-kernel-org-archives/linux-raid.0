From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] Use disk sector size value to set offset for reading GPT
Date: Tue, 13 Dec 2016 16:38:51 +0000
Message-ID: <5850241B.8030007@youngman.org.uk>
References: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>, linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com
List-Id: linux-raid.ids

On 08/12/16 11:13, Mariusz Dabrowski wrote:
> mdadm is using invalid byte-offset while reading GPT header to get
> partition info (size, first sector, last sector etc.). Now this offset
> is hardcoded to 512 bytes and it is not valid for disks with sector
> size different than 512 bytes because MBR and GPT headers are aligned
> to LBA, so valid offset for 4k drives is 4096 bytes.
> 
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>

Could this be behind the couple of incidents recently, where an array
has been moved from one machine to another, and the GPT has disappeared?

I know I've been following the threads, and I've been puzzled in that
I've thought "nothing should be writing there!"

If it is, what mdadm/kernels are affected, and I can put it on the wiki,
writing the page up about corrupted disks is next on my list.

Cheers,
Wol

