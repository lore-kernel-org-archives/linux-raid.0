From: Michal Soltys <soltys@ziu.info>
Subject: Re: Kernel doesn't find root from new style partitionable array
Date: Mon, 12 Jan 2009 00:26:13 +0100
Message-ID: <496A8015.5000704@ziu.info>
References: <871vvbulaz.fsf@divinity.mikat.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871vvbulaz.fsf@divinity.mikat.iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Mika Tiainen <mikat@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mika Tiainen wrote:
> Hi,
> 
> When booting from another disk I can see that the md0 partitions are
> only found later:
> 
>  md0: p1 p2
> 
> This line shows up after root is already mounted.
> 

I've never used in-kernel raid autodetection (always relying on 
initramfs - any reason not to use one ?), but looking at md.txt from 
kernel docs, raid=partitionable parameter should get it done. You might 
end with md_d0 (as in earlier kernels) name instead of md0, so adjust 
root=, fstab, etc. accordingly.

