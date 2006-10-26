From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: mdadm: bitmaps not supported by this kernel?
Date: Wed, 25 Oct 2006 20:25:15 -0400
Message-ID: <4540006B.70808@steeleye.com>
References: <453FD41B.5080908@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453FD41B.5080908@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Another 32/64 bits issue, it seems.
> Running 2.6.18.1 x86-64 kernel and mdadm 2.5.3 (32 bit).
> 
> # mdadm -G /dev/md1 --bitmap=internal
> mdadm: bitmaps not supported by this kernel.
> 
> # mdadm -G /dev/md1 --bitmap=none
> mdadm: bitmaps not supported by this kernel.
> 
> etc.
> 
> Recompiling mdadm in 64bit mode eliminates the problem.


I think this is due to the bug I reported a month or so ago. We were 
missing a COMPATIBLE_IOCTL entry for the GET_BITMAP_FILE ioctl. Neil has 
sent in the patch.


> So far, only bitmap manipulation is broken this way.
> I dunno if other things are broken too - at least
> --assemble, --create, --stop, --detail works.


Yeah, I think everything else works.

--
Paul
