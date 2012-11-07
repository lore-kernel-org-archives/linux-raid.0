From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Wed, 07 Nov 2012 21:44:47 +0800
Message-ID: <509A65CF.8020409@fnarfbargle.com>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se> <20121105162227.7bc5c103@notabene.brown> <5099BC6B.7030500@fnarfbargle.com> <509A3029.4050402@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <509A3029.4050402@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: NeilBrown <neilb@suse.de>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/12 17:55, joystick wrote:

>
> we still need someone to test the other case, a more common scenario I'd
> say: the disk to be replaced fails during hot-replace

I suspect I can do that by creating some "media errors" using hdparm 
while the replacement is in progress.

I'd have *thought* that the procedure should be to re-direct the read to 
another mirror (it is a raid-10 after all).

>> The test machine is on UPS, so I have not done any testing that
>> involves reboots during a re-sync.
>
> And also this one...
> Best simulation would be unpulling the plug so that disks do not flush
> if you have still time for us, of course :-)

I assume to test that adequately (as in re-assemble an array with a 
replacement in progress) I'd need to upgrade mdadm to the latest git code?

No biggie, just requires a bit more tweaking the initramfs stuff.

The tests thus far have been conducted in spare drive slots in my 
production server. This afternoon I picked up a new motherboard for my 
test box so tomorrow I'll have a dedicated machine to play with.

Debian on SSD, and 10 x 1TB 7200 RPM drives that have been retired from 
active hard service (they have about 22,000 hours on them) and ready as 
a test mule.

If you put together a set of tests you'd like performed I'll be happy to 
run them and see what happens. The machine is on a managed APC PDU (yay 
Gumtree!), so remote power cycling is a lot easier than it used to be 
and I really don't mind hammering the disks with emergency parks or 
excessive cycles.


