From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: removing AHCI SATA devices
Date: Wed, 23 Feb 2011 11:19:27 +0000
Message-ID: <4D64ED3F.4050106@anonymous.org.uk>
References: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com> <4D642C54.9040604@garzik.org> <4D64C503.1080304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D64C503.1080304@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/02/2011 08:27, Simon McNair wrote:
> thanks Jeff. It just seems like a hit and miss solution (no way of
> knowing all data has been written to and that the device has been
> unmounted from all filesystems). I kinda expected some kind of 'it is
> safe to remove /dev/sdb' in dmesg.

I think `eject /dev/sdb` will do what you want - if it's safe to pull, 
it'll exit immediately and silently, but if it or any of its partitions 
are still associated with any filesystem or md device, and the drive 
can't safely be ejected/unplugged, it'll complain.

Cheers,

John.

