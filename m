From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - *Slow SSDs likely solved*
Date: Fri, 15 Feb 2013 22:33:36 -0600
Message-ID: <511F0C20.1000005@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <511361B3.8060204@hardwarefreak.com> <51137C57.7070509@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51137C57.7070509@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/7/2013 4:05 AM, Adam Goryachev wrote:

> Storage server:
...
> 5 x Intel 520s MLC 480G SATA3
> Debian Stable .. *kernel 2.6.32-5-amd64*

There was a regression in 2.6.32 kernels that hammered SSD performance.
 Upgrade to linux-image-3.2.0-0.bpo.3-amd64 and it should fix it.  See:

http://www.archivum.info/linux-ide@vger.kernel.org/2010-02/00243/bad-performance-with-SSD-since-kernel-version-2.6.32.html

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642729

It was reverted in 2.6.33 upstream, and supposedly reverted in 2.6.32
upstream stable.  But apparently, according to Ben Hutchings last
comment in the Debian bug report, it hasn't been fixed yet in Debian
2.6.32, and that was over a year ago.

BTW, did you get the LSI card into the server yet, and if so have you
run any FIO tests to compare with the previous onboard SATA2 numbers you
posted?  Would be interesting to see what performance advantage, if any,
it has over the onboard SATA2, and would also allow us to see just how
much difference the new kernel makes.

Also, which LSI board did you get, the 9211 or 9307?  You simply said
you got the "recommended" one, or something like that.

-- 
Stan

