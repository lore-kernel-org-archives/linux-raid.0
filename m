From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 01:15:36 +0100
Message-ID: <200501040115.36729.maarten@ultratux.net>
References: <200501032136.j03LaJ915438@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501032136.j03LaJ915438@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 03 January 2005 22:36, Guy wrote:
> Maarten said:
> "Doing the math, the outcome is still (200% divided by four)= 50%.
> Ergo: the same as with a single disk.  No change."
>
> Guy said:
> "I bet a non-mirror disk has similar risk as a RAID1."
>
> Guy and Maarten agree, but Maarten does a better job of explaining it!  :)
>
> I also agree with most of what Maarten said below, but not mirroring
> swap???

Yeah... bad choice in hindsight.  
But, there once was a time, a long long time ago, that the software-raid howto 
explicitly stated that running swap on raid was a bad idea, and that by 
telling the kernel all swap partitions had the same priority, the kernel 
itself would already 'raid' the swap, ie. divide equally between the swap 
spaces. I'm sure you can read it back somewhere.

Now we know better, and we realize that that will indeed loadbalance between 
the various swap partitions, but it will not provide redundancy at all.  
Oh well, new insights huh ? ;-)

Maarten



