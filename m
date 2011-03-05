From: Ken Drummond <linuxraid@kendrummond.com>
Subject: RE: Impact of missing parameter during mdadm create
Date: Sat, 05 Mar 2011 16:37:35 +1000
Message-ID: <1299307055.4999.8.camel@tankquad>
References: <BAY148-w59357147C486E15E514067EFC50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w59357147C486E15E514067EFC50@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2011-03-04 at 23:22 -0500, Mike Viau wrote:

> Attached HOST_SYSLOG.txt is the _complete_ syslog after a system reboot showing only 2 drives are assembled automatically on boot, and the array is degraded.
> 
> 

OK, I guess I should have thought of this before, your syslog shows that
sdd is attached as a USB device and is not discovered until after md0
has been assembled (using all the devices available at the time).  I'm
not sure how you would make md auto assembly wait until after your USB
device has been discovered.  Hopefully someone else here can provide
some advice, although it's not strictly a linux-raid issue there are
quite a few helpful people here.

I'm pretty sure if you replaced the USB device with another SATA device
things would work as you expected. Another alternative may be to not
have that array auto assembled but wait and assemble after the boot is
finished, this could probably be scripted.

Ken.

