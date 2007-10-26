From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 26 Oct 2007 18:22:27 +0200
Message-ID: <20071026162226.GB28982@boogie.lpds.sztaki.hu>
References: <18200.53593.687483.120827@stoffel.org> <1192810534.1666.68.camel@firewall.xsintricity.com> <18200.56684.14194.630264@stoffel.org> <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com> <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com> <20071026095417.GC32550@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071026095417.GC32550@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 26, 2007 at 11:54:18AM +0200, Luca Berra wrote:

> but the fix is easy.
> remove the partition detection code from the kernel and start working on
> a smart userspace replacement for device detection. we already have
> vol_id from udev and blkid from ext3 which support detection of many
> device formats.

You got the ordering wrong. You should get userspace support ready and
accepted _first_, and then you can start the
flamew^H^H^H^H^H^Hdiscussion to make the in-kernel partitioning code
configurable. But even if you have the perfect userspace solution ready
today, removing partitioning support from the kernel is a pretty
invasive ABI change so it will take many years if it ever happens at
all.

I saw the "let's move partition detection to user space" argument
several times on l-k in the past years but it never gained support...
So if you want to make it happen, stop talking and start coding, and
persuade all major distros to accept your changes. _Then_ you can start
arguing to remove partition detection from the kernel, and even then it
won't be easy.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
