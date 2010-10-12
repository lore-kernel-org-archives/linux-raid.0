From: Tim Small <tim@seoss.co.uk>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 12 Oct 2010 14:59:56 +0100
Message-ID: <4CB469DC.5040100@seoss.co.uk>
References: <4C938103.1010304@seoss.co.uk>	<20100918085925.5fee83ee@notabene>	<4C97BD21.1040405@seoss.co.uk>	<4C991D61.1040400@seoss.co.uk> <20100922083039.283ccdfd@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100922083039.283ccdfd@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/09/10 23:30, Neil Brown wrote:
>
> Maybe if you can get me a full sysrq-T list that might help.
>    

Just thought I'd follow up on this - it's being a right bastard...

sysrq-T and a 1M buffer works fine when the box isn't in the IO-hung 
state, but makes it crash immediately when it is.  sysrq-T without the 
1M buffer works fine.

I tried getting the console output using a serial console (+IPMI over 
LAN), but the box doesn't seem to work correctly with serial console 
(output is fine til part-way through the boot process, thereafter is 
stops, and anything to /dev/console doesn't appear on the serial port, 
although I/O to /dev/ttyS1 works fine).

OK, so I'll use netconsole - nope, netconsole doesn't work on this box 
either - all I see on the remote machine is a perfectly fine UDP header, 
but the body of the packet is all 0x0s.

I'll try and see what it's doing when I'm physically in front of a VGA 
console at some point.

Thanks,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

