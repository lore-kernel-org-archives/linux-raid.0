From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Help
Date: Sat, 22 Aug 2009 17:47:48 +0100
Message-ID: <4A902134.2020009@anonymous.org.uk>
References: <200908210627.06241.Info@quantum-sci.net> <200908212314.31887.Info@quantum-sci.net> <3d3031d0053a547684fa49ddc6532819.squirrel@neil.brown.name> <200908220556.32856.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908220556.32856.Info@quantum-sci.net>
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/08/2009 13:56, Info@quantum-sci.net wrote:
[...]
> It is very lucid and clear, however I am slightly modifying it to use RAID10 on my second and third partitions.  When I come to 
> update-initramfs -u
> ... the only initrd it updates is for an old stock kernel.  It doesn't build one for any of my compiled kernels.

You should have mkinitrd (that's what it is on Fedora/RHEL/CentOS) or 
something similar with which you can build initramfs images for any kernel.

> What partition type should I use rather than raid autodetect?  Or should I revert to 0.90 metadata?

Probably type DA, Non-FS data, though type FD will be fine even if 
they're not auto-detected.

> Looking at dmesg it does say that md1 & 2 do not have a valid ==v.90== superblock.  There is no other linux raid partition type, so I guess it's got to be v.090.  Why do they make 1.1 and 1.2 then, if they do not work?

The newer metadata types have their benefits. Auto-detection is being 
deprecated, I think it's because things which are only for boot-up time 
are being pushed out of the permanently-loaded kernel into initramfs, so 
they don't hang around wasting space on a running system. For example, 
CentOS 5 uses autodetection, Fedora 10 automatically puts mdadm in the 
initramfs and runs it at the right time.

Cheers,

John.

