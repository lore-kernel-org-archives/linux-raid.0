From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Automatically adding spares on boot
Date: Sat, 19 Jan 2013 09:23:03 +0100
Message-ID: <50FA57E7.3020608@gmail.com>
References: <50EDA431.1090905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50EDA431.1090905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/09/2013 06:09 PM, Can Jeuleers wrote:
> Hi,
> 
> Over the years I've had various problems with the degree to which the
> adding of spares on boot is automatic. There have been times when this
> has just worked, and other times (such as now) where it only works very
> occasionally (or not at all). Google is full of stories like this.
> 
> I have no clue why it's not working automatically, I just know that it
> isn't.
> 
> So I wrote a little script that automates this, and hooked it up to
> mdmon as an event handler.
> 
> It can probably do with an elegance upgrade, but it works for me.
> 
> HTH, Jan

Here is sample output of the script, which it mails to root:

The UUID of component devices is 442e9934:97191d8e:6d0cf7a9:41621837
(442e9934-9719-1d8e-6d0c-f7a941621837)
Device /dev/sdb2 is already a member of the array
Device /dev/sdd2 is already a member of the array
Found device /dev/sde3 with the same UUID but not yet a component device.
mdadm: re-added /dev/sde3

It's a great shame that there does not appear to be a standard format
for representing UUIDs: mdadm uses an 8:8:8:8 format, whereas blkid
wants an 8-4-4-4-12 format. Hence the conversion shenanigans in the
script. Makes the code brittle.

Cheers, Jan
