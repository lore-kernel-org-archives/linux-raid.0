From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: raw I/O support for Fedora Core 4
Date: Thu, 23 Mar 2006 11:07:15 +0100
Message-ID: <1143108435.3147.21.camel@laptopd505.fenrus.org>
References: <WM57DB3DF98115400697C908A54A80DEE9@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751411AbWCWKHT@vger.kernel.org>
In-Reply-To: <WM57DB3DF98115400697C908A54A80DEE9@spsoftindia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2006-03-23 at 14:54 +0530, Yogesh Pahilwan wrote:
> Hi All,
> 
> I want to do raw I/O on MD RAID and LVM for fedora core 4(kernel 2.6.15.6).
> 
> After doing googling I came to know that "raw" command does the raw
> operation by linking 
> MD device and LVM volume to the raw device as 
> 
> # raw /dev/raw/raw1 /dev/md0.
> 
> But when I search on this I came to know that there is no raw (/dev/rawctl)
> device support available with 2.6 kernel.
> I have also tried recompile the kernel sources with raw device support it is
> not getting compiled as it is obsolete in 2.6. 
> If I want to include raw device support in my kernel what should I will have
> to do, so that I 

the preferred interface is doing O_DIRECT io on the device node itself,
rather than going via a (slower) indirection layer such as "raw". ("raw"
is just a wrapper on top of O_DIRECT basically in 2.6 kernels so slower)
