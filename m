From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: Smartmontools on software RAID
Date: Sun, 18 Nov 2012 17:20:15 -0500
Message-ID: <50A95F1F.4080000@meetinghouse.net>
References: <CANSbrrotWforxJj-nQ_KJ4Y=jGGFaCubCdUjqv8bLJ6Tn5CUgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSbrrotWforxJj-nQ_KJ4Y=jGGFaCubCdUjqv8bLJ6Tn5CUgA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Anuj Goel wrote:
> Hi,
>
> Can smartmontools be used with software RAID ?
> I see that it has support for RAID, but that is based on the Hardware
> controller.
>
>
Well... I use it every day to monitor the disks under my RAID arrays.  
All you have to do is point it at the hardware device (e.g., /dev/hda), 
not the raid device.

The RAID arrays I monitor with mdadm.

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

