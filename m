From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: Problem with RAID5 and USB2 using 2.4.27
Date: Sat, 11 Dec 2004 08:36:07 -0500
Message-ID: <6d5bedd804121105367ffd0351@mail.gmail.com>
References: <6d5bedd804121004026c153b59@mail.gmail.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd804121004026c153b59@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 10 Dec 2004 06:02:00 -0600, Ewan Grantham
<ewan.grantham@gmail.com> wrote:
> Have a 4-disk RAID 5 array of 250Gig HDs that I am looking to use for
> performing video capture and editing. Two of the disks are internal,
> and two are external and connected using a USB2 card. Running under a
> Debian installation with a 2.4.27 kernel, I can capture for a few
> minutes, but then I start to drop frames, and the percentage dropped
> gets worse as time goes on.

Well, I got my answer by using a second card and moving to kernel
2.6.7 - sort of.

Put in the second card, and it showed up in usbview, but the disk
attached to it showed up as being attached to an "unknown" usb hub at
only 1.1 speed.

Figured this might be a 2.4 kernel issue (with USB), and so rebooted
into kernel 2.6.7. Nope, the second card still showed up "funny".
However I had somehow convinced it to load ehci-hcd (had not been able
to do that before) and so the first disk was running at Hi Speed.

Just for grins I pulled the second drive off the second card, and
plugged it back into the first card. Now both disks were showing hi
speed.

Having read that the USB drivers for kernel 2.6 were more "efficient",
I decided to see what would happen. Sure enough, I can now capture (at
least 30 minutes) without a single dropped frame.

So, adding a second card evidently did "fix" the problem, just not directly :-)

Guess this means RAID-5 under a 2.6.7 kernel is possible using USB.
I'd still "ideally" like to use the second USB card, but with it
running so well I'm a little disinclined to touch anything at this
point...

FWIW,
Ewan
