From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: raid5 bitmap performance
Date: Thu, 26 Oct 2006 15:40:54 -0400
Message-ID: <45410F46.4080705@steeleye.com>
References: <20061026183015.GA20602@cm.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061026183015.GA20602@cm.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shane wrote:

> I just thought I'd give internal bitmaps a try using mdadm
> -G -b internal and the write speed:
> dd if=/dev/zero of=test.dat oflag=dsync bs=1024k count=1024
> went from 20mbps to 15mbps.  Is that a typical hit for the
> bitmap?  I don't resync very often so it may not be
> necessary.  Just wondering whether there is anything that
> should be tuned.

You could try tuning the bitmap chunk size. The bitmap chunk size 
determines how much data each bit represents, so it determines how often 
the bitmap has to be updated when you're writing data to the array. By 
default, it's set according to whatever can fit into the space between 
the md superblock and the end of the disk (typically 60KB). If you have 
small disks, the chunk size will be 4K, and it goes up from there 
depending on the size of the disks (typically in the range of 64KB-256KB).

You might try a bitmap chunk size of a megabyte or several megabytes and 
see if that improves things. It'll mean less seeking of the disk head to 
do the bitmap updates.

--
Paul

