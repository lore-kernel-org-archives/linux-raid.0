From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 11:26:14 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40292246.2030902@backtobasicsmgmt.com>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk> <1076425115.23946.18.camel@leto.cs.pocnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1076425115.23946.18.camel@leto.cs.pocnet.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christophe Saout wrote:

> I have a really bad idea :)
> 
> Try to combine it with udev. udev calls the ide script, the ide script
> then calls the ataraid detector. If the device is non-ataraid, go on as
> usual. If it is, build the device-mapper device and symlink (if it
> doesn't already exist) and tell udev to not create anything.

This is not a bad idea, it's the future. The hotplug mechanism is 
exactly what should be used here. When a block-device hotplug ADD event 
occurs, you look at that device to see if it's something you care about. 
If not, just exit and leave it alone.

Now in the ATARAID case, where you need to see multiple devices before 
you can do anything with them, this means you'd need to keep some 
"state" somewhere about the devices you've seen so far, and the partial 
ATARAID devices they represent. When you get the hotplug event for the 
last piece of a particular ATARAID device, you use DM/MD to set up the 
device and make it available.

The wonderful part of this is, when you do that last step, _another_ 
block-device hotplug ADD event occurs for the new device you just 
created, and if the hotplug scripts are set up to run dmpartx or its 
equivalent for new block-devices, you are done. The partition tables 
_inside_ the ATARAID device will be read, more DM calls will be made to 
make those sub-devices available to userspace and everyone is thrilled 
about the elegance of the solution :-)

