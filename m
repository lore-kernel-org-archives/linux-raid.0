From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: SW-RAID 1 and kernel 2.4.18
Date: Tue, 26 Nov 2002 15:05:02 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1021126145831.1637A-100000@Maggie.Linux-Consulting.com>
References: <as0tvm$lu$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <as0tvm$lu$1@cesium.transmeta.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya

On 26 Nov 2002, H. Peter Anvin wrote:

> Followup to:  <3DE3CC8D.2080104@mvista.com>
> By author:    Steven Dake <sdake@mvista.com>
> In newsgroup: linux.dev.raid
> > 
> > IDE was not designed to hotswap.  The trays are not "hot swappable" in 
> > that they can only be swapped while the system is off.
> > 
> 
> There are IDE cards which can tristate -- effectively disconnect -- their
> outputs.  Some of them can even control the power to the drive.  Such
> drives are safe to hotswap, if they have been disconnected before
> removing them.  This requires driver support, however, and I'm not
> sure if Linux has that.

electrical hotswap is easy to implement ?? ( many different ways )
since one has to make the hotswap tray too ..

i think the problem is after the new drive is inserted, how does
the IDE drivers know to start rewriting all the data to the fresh/virgin
disk .. that was aborted during the time it was previously attempting
to write a 4GB file when the disk was pulled out...
	- if the raid drivers can do all the right magic...
	it should be good to build a nice tri-stated hotwap ide tray

	( to me.. powering up a system with the system power switch or
	( inserting a disk into a properly isolated ide connectors
	( is the same issue... start the motors... than allow the cable
	( connections than the normal system access to the disks

c ya
alvin
http://www.Linux-1U.net
...  9" 1U w/ 2-4 laptop drives
... 26" 1U w/ 8x 180GB drives - 1.6TB - 1U-Raid5[tm]

