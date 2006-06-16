From: Neil Brown <neilb@suse.de>
Subject: Re: to understand the logic of raid0_make_request
Date: Fri, 16 Jun 2006 14:32:58 +1000
Message-ID: <17554.13434.191935.975865@cse.unsw.edu.au>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
	<17550.2944.728044.154492@cse.unsw.edu.au>
	<4558af040606151953g2ae4c1aasb0c398294cda5887@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from liu yang on Friday June 16
Sender: linux-raid-owner@vger.kernel.org
To: liu yang <liudows2@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 16, liudows2@gmail.com wrote:
> 
> 
> Thanks a lot.I went through the code again following your guide.But I
> still can't understand how the bio->bi_sector and bio->bi_dev are
> computed.I don't know what the var 'block' stands for.
> Could you explain them to me ?

'block' is simply "bi_sector/2" - the device offset in kilobytes
rather than in sectors.

raid0 supports having different devices of different sizes.
The array is divided into 'zones'.
The first zone has all devices, and extends as far as the smallest
devices.
The last zone extends to the end of the largest device, and may have
only one, or several devices in it.
The may be other zones depending on how many different sizes of device
there are.

The first thing that happens is the correct zone is found by lookng in
the hash_table.  Then we subtract the zone offset, divide by the chunk
size, and then divide by the number of devices in that zone.  The
remainder of this last division tells us which device to use.
Then we mutliply back out to find the offset in that device.

I know that it rather brief, but I hope it helps.

NeilBrown
