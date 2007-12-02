From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: Spontaneous rebuild
Date: Sun, 02 Dec 2007 14:07:33 +0100
Message-ID: <4752AE15.7000301@student.tuwien.ac.at>
References: <475230AF.3010100@student.tuwien.ac.at> <Pine.LNX.4.64.0712020445160.30169@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712020445160.30169@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz schrieb:
> 
> It rebuilds the array because 'something' is causing device
> resets/timeouts on your USB device:
> 
> Dec  1 20:04:49 quassel kernel: usb 4-5.2: reset high speed USB device
> using ehci_hcd and address 4
> 
> Naturally, when it is reset, the device is disconnected and then
> re-appears, when MD see's this it rebuilds the array.
> 
> Why it is timing out/resetting the device, that is what you need to find
> out.
> 
> Justin.
> 

Thanks for your answer, I'll investigate the USB resets. Still, it seems
strange that the rebuild only started five hours after the reset. Is
this normal?
The reason I said the resets don't seem to hurt is that I also get them
for a second disk (not in a raid), and file transfers aren't
interrupted, I haven't (yet?) seen any data corruption, and other than
the message, the kernel doesn't seem to mind at all.

BTW, this time, badblocks ran through without any errors. The only
strange thing remaining is the rebuild.


Oliver
