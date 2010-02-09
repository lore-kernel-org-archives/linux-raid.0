From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Feature Request
Date: Tue, 09 Feb 2010 15:28:10 +0300
Message-ID: <4B7154DA.90405@msgid.tls.msk.ru>
References: <4B712034.1000600@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B712034.1000600@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan *St0fF* Huebner wrote:
[]
> Now imagine any RAID with some kind of redundancy, reading/writing
> data.  One of the disks finds out "I cannot correctly read/write the
> requested sector", starts its error correction, hits the respective
> ERC-timeout and reports back a media error or unrecoverable error.  Now
> mdraid would drop the disk.
> 
> But actually the data of the sector can be recreated through the
> existing redundancy.  Wouldn't it be a smart thing if the mdraid
> recreates the sector and just tried to write it again?  And after a good
> amount of failed retries it may well drop the disk.

This is exactly what md layer is doing.  On failed _read_ it tries to
reconstruct data from other disk drives and writes the reconstructed
data back to the drive where read failed.  If the _write_ fails md will
drop the disk.

/mjt
