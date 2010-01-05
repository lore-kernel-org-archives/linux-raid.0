From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Linear mode: array size is less than sum of sizes
Date: Tue, 05 Jan 2010 20:06:32 +0000
Message-ID: <4B439BC8.1030908@anonymous.org.uk>
References: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alessandro Baretta <alexbaretta@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/01/2010 18:21, Alessandro Baretta wrote:
> Hi guys.
> 
> I have a bizarre problem. Hopefully someone will provide some insight.
[...]
> As you can see the computed size is 67 sectors less than the reported
> size. What happened to those sectors?

At the very least md linear mode will round down the constituent devices 
to multiples of the rounding size, which is the same as the chunk size - 
see `man mdadm` for rounding size. The default 64K is 128 sectors, and 
probably explains what's happened to your 67 sectors - sda1 has its last 
65 sectors ignored, and sda5 2. You specify the chunk size in KiB not 
sectors so I don't know how you're going to fix this, and I've a feeling 
performance would be woeful even if you could have a 1-sector chunk size.

> They are surely not used to
> store superblocks, as the --build command does not create superblocks.
> If they are used for the md driver's magic, do they all come from the
> first device of the array or are they distributed on both? All in all,
> how safe (or unsafe) is my approach to virtualizing Windows XP on my
> Linux box?

I don't really know how safe it is, but I don't like your 16002-sector 
thingy. If you're going to do this I can't help thinking you should 
duplicate the real partition table, showing the partition starting on 
sector 63, so you want 63 extra sectors, not 16002. You might do it 
using a file on your filesystem via loopback instead of messing about 
with a silly 1-cylinder partition.

> Thank you in advance for any help you can provide.

Good luck and let me/us know how you get on!

Cheers,

John.
