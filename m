From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 1 and grub
Date: Thu, 31 Jan 2008 16:06:41 +1300
Message-ID: <47A13B41.50406@sauce.co.nz>
References: <47A0F4DC.9030005@sauce.co.nz>	 <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>	 <47A13379.50703@sauce.co.nz> <72dbd3150801301847s6bbfa958h1213e782627e64a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150801301847s6bbfa958h1213e782627e64a1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Rees wrote:

> FWIW, this step is clearly marked in the Software-RAID HOWTO under
> "Booting on RAID":
> http://tldp.org/HOWTO/Software-RAID-HOWTO-7.html#ss7.3

The one place I didn't look...


> BTW, I suspect you are missing the command "setup" from your 3rd
> command above, it should be:
> 
> # grub
> grub> device (hd0) /dev/hdc
> grub> root (hd0,0)
> grub> setup (hd0)

That is correct.

Regards,

Richard
