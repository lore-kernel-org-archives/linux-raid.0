From: Neil Brown <neilb@suse.de>
Subject: Re: raid 4, and bitmap.
Date: Fri, 3 Feb 2006 11:09:35 +1100
Message-ID: <17378.40767.339455.85486@cse.unsw.edu.au>
References: <04c201c62855$5efda450$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Friday February 3
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 3, djani22@dynamicweb.hu wrote:
> Hello, list, Neil,
> 
> I try to add bitmaps to raid4, and mdadm is done this fine.
> In the /proc/mdstat shows this, and it is really works well.
> 
> But on reboot, the kernel drops the bitmap(, and resync the entire array if
> it is unclean). :(
> 
> It is still uncomplete now? (2.6.16-rc1)


It is an 'internal' bitmap, or is the bitmap in a file?

If the bitmap is in a file, you need to me sure that the file is
provided by mdadm when the array is assembled - using in-kernel
autodetect won't work.

If it is an internal bitmap.... it should work.  
Are there any kernel messages during boot that might be interesting?

NeilBrown
