From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Fri, 2 Mar 2007 17:02:27 +0100
Message-ID: <20070302160227.GD31010@boogie.lpds.sztaki.hu>
References: <45E82EF8.9000106@laurelnetworks.com> <Pine.LNX.4.64.0703021039520.13743@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703021039520.13743@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 02, 2007 at 10:40:32AM -0500, Justin Piszcz wrote:

> AFAIK mdadm/kernel raid can handle this, I had a number of occaisons when 
> my UPS shut my machine down when I was rebuilding a RAID5 array, when the 
> box came back up, the rebuild picked up where it left off.

_If_ the resync got far enough that the kernel image is already copied.
The original mail is about the case when the sectors where the
kernel/initramfs should be are not yet synced...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
