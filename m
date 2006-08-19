From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Sat, 19 Aug 2006 03:13:53 +0200
Message-ID: <20060819011353.GG6440@boogie.lpds.sztaki.hu>
References: <44E250CD.5040308@aol.com> <20060816073854.GA7356@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060816073854.GA7356@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 16, 2006 at 09:38:54AM +0200, Luca Berra wrote:

> The only risk is if you ever move one disk from one machine to another.
> To work around this you can change the uuid by recreating the array with
> mdadm,

No need to re-create, --update=uuid should be enough according to the
man page.

> but you would have to regenerate the initrd and fight again with lilo :(

Or you can just build a kernel with md built-in and use the kernel-level
RAID autodetection. In situations like this it is _much_ easier and
_much_ more robust than all the initrd-based solutions I have seen.

Also, if you install lilo to the RAID device instead of the MBR, and
install a bog-standard MBR using the install-mbr command on every drive,
your life will be easier.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
