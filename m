From: Alessandro Baretta <alexbaretta@gmail.com>
Subject: Re: Linear mode: array size is less than sum of sizes
Date: Wed, 6 Jan 2010 23:14:54 +0100
Message-ID: <f4143ac21001061414jc5584e3n2015d0e93c2d8d3c@mail.gmail.com>
References: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>
	 <4B439BC8.1030908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B439BC8.1030908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: "john.robinson" <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

Hi again John.

On Tue, Jan 5, 2010 at 9:06 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
>
> I don't really know how safe it is, but I don't like your 16002-sector
> thingy. If you're going to do this I can't help thinking you should
> duplicate the real partition table, showing the partition starting on sector
> 63, so you want 63 extra sectors, not 16002. You might do it using a file on
> your filesystem via loopback instead of messing about with a silly
> 1-cylinder partition.

You were right. No way to get the Windows bootloader to even try
starting up Windows unless the windows partition is exactly at the
safe offset from as it is in the original drive. Too bad that Windows
dies with a BSOD while booting... That's with qemu-kvm 0.11.0 and
Linux 2.6.30 on Debian Sneezy. Oh, well. I'll just try to avoid
booting into Windows...

Alex
