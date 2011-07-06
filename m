From: Phil Turmel <philip@turmel.org>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Wed, 06 Jul 2011 13:00:43 -0400
Message-ID: <4E1494BB.9060101@turmel.org>
References: <20110706161228.GA1491@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110706161228.GA1491@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Louis-David,

On 07/06/2011 12:12 PM, Louis-David Mitterrand wrote:
> Hi,
> 
> After a hardware crash I can no longer open a dm-crypt partition located
> directly over a md-raid6 partition. I get this error:
> 
> 	root@grml ~ # cryptsetup isLuks /dev/md1 
> 	Device /dev/md1 is not a valid LUKS device
> 
> It seems the LUKS header has been shifted a few bytes forward, but looks
> otherwise fine to specialists on the dm-crypt mailing list. Normally the
> "LUKS" signature should be at 0x00000000
> 
> Is there some way that the md layer could have shifted its contents?
> 
> Is there a way to shift it back in place?
> 
> Thanks,
> 
> 
> Here is a hexdum of /dev/md1 done with "hd /dev/md1 | head -n 40"
> 
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes.....|
> 00100010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00100020  00 00 00 00 00 00 00 00  63 62 63 2d 65 73 73 69  |........cbc-essi|
> 00100030  76 3a 73 68 61 32 35 36  00 00 00 00 00 00 00 00  |v:sha256........|

[...]

The offset is precisely 1MB.  This is the default data offset for metadata types 1.1 and 1.2 (nowadays).  Metadata types 0.90 and 1.0 have a zero offset (the metadata is at the end.)

You don't say what your recovery efforts were, but I'd guess you did a "mdadm --create" somewhere in there, and didn't match the original parameters.  Or you used an older version of mdadm than was used originally, and therefore got different defaults.

Another possibility is that the original array was set up on a 1MB aligned partition, and the array is now using the whole device.  This can happen with v0.90 metadata.  If so, the original partition table is obviously zeroed out now.

Please share more information about what you've done so far.  Also show us the output of "mdadm -D /dev/md1" and then "mdadm -E /dev/xxx" for each of its components.

The output of "lsdrv"[1] would also be useful for visualizing your setup.

Regards,

Phil

[1] http://github.com/pturmel/lsdrv

