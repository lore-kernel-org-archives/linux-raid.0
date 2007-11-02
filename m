From: Michal Soltys <nozo@ziu.info>
Subject: Re: stride / stripe alignment on LVM ?
Date: Fri, 02 Nov 2007 13:10:07 +0100
Message-ID: <472B139F.9060903@ziu.info>
References: <20071101101037.63b523f8@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071101101037.63b523f8@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Janek Kozicki <janek_listy@wp.pl>
List-Id: linux-raid.ids

Janek Kozicki wrote:
> 
> And because LVM is putting its own metadata on /dev/md1, the ext3
> partition is shifted by some (unknown for me) amount of bytes from
> the beginning of /dev/md1.
> 

It seems to be multiply of 64KiB. You can specify it during pvcreate, with 
--metadatasize option. It will be rounded to multiply of 64 KiB, and will 
add another 64 KiB on its own. Extents will follow directly after that. 4 
sectors mentioned in pcvreate's man page are covered by that option as well.

So i.e. if you have chunk 1MiB, then pvcreate ... --metadatasize 960K ...
should give you chunk-aligned logical volumes, assuming you have actual 
extent size set appropriately as well. If you use default chunk size, you 
shouldn't need any extra options.

Make sure if it really is this way, after pv/vg/first lv creation. I found 
it experimentally, so ymmv.
