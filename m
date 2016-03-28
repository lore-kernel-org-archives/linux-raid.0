From: "John Stoffel" <john@stoffel.org>
Subject: Re: Looking to pick PCIe x4/x8 4+ SATA expansion card recommendation.
Date: Mon, 28 Mar 2016 16:07:10 -0400
Message-ID: <22265.36590.539103.542573@quad.stoffel.home>
References: <56F97B91.4070302@gmail.com>
	<22265.33776.226233.227426@quad.stoffel.home>
	<22265.34078.125691.255754@quad.stoffel.home>
	<56F98958.3020704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56F98958.3020704@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Ram" == Ram Ramesh <rramesh2400@gmail.com> writes:

Ram> On 03/28/2016 02:25 PM, John Stoffel wrote:
>> I just went back and checked, and I got the:
>> 
>> LSI 9211 SAS9211-8i 8port low profile 6Gb/s SAS Host Bus Adapter
>> 
>> which was a DELL brand controller.  The 9207 is another model which is
>> also recommended, but this is from 2014 or even earlier.   There might
>> be newer models out there.
>> 
>> I paid $123 plus shipping.  Been very happy with it, not problems at
>> all.
Ram> I searched your description and got this
>> http://www.ebay.com/itm/LSI-SAS-9211-8i-6Gbps-8Port-PCI-Express-SATA-SAS-Host-Bus-Adapter-Hot-/380703631558

Ram> Is this the one you are talking about? In my message I mentions this,
>> www.ebay.com/itm/like/252048579357?lpid=82&chn=ps&ul_noapp=true 

That looks very much how I remember mine.  Make sure you get a full
height bracket when you order, that was one of the things I had to
check as I recall now, since I have a full height tower system, not a
2U rack mounted system.  

Ram> Mine is cheaper, so it worries me (BTW, for LSI 9211-8i, the
Ram> prices are all over the place). Yours claims RAID capability
Ram> (assuming IR firmware) and the other seem to be no raid (may be
Ram> IT firmware)

I just flashed the standard LSI firmware from their site as I recall.
I disabled any hardware RAID stuff as well.   Since I can't just
bounce the system to check, take what I say with a grain of salt.

Ram> Both are from China, and like you say, not sure what I will get.

I seem to recall I got it from someone in the US.  


The other trick I did was to put all my data volumes on the LSI
controller, and just a pair of SSDs onto the internal SATA
controllers.  This way I know which devices I'll boot from, and it
made it simpler to know I had updated and setup GRUB properly.

You do want to test booting from a broken RAID1 boot device.  When I
recently did my big re-org, I found that to make it boot I had to move
the working boot drive to the non-working slot, since of course the
failed one was effectively /dev/first-drive and that's how grub needed
to boot.

John
