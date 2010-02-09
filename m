From: =?ISO-8859-15?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: Feature Request
Date: Tue, 09 Feb 2010 15:19:58 +0100
Message-ID: <4B716F0E.7040306@stud.tu-ilmenau.de>
References: <4B712034.1000600@gmx.net> <4B7154DA.90405@msgid.tls.msk.ru>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7154DA.90405@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 09.02.2010 13:28, schrieb Michael Tokarev:
> Stefan *St0fF* Huebner wrote:
> []
>> Now imagine any RAID with some kind of redundancy, reading/writing
>> data.  One of the disks finds out "I cannot correctly read/write the
>> requested sector", starts its error correction, hits the respective
>> ERC-timeout and reports back a media error or unrecoverable error.  Now
>> mdraid would drop the disk.
>>
>> But actually the data of the sector can be recreated through the
>> existing redundancy.  Wouldn't it be a smart thing if the mdraid
>> recreates the sector and just tried to write it again?  And after a good
>> amount of failed retries it may well drop the disk.
>
> This is exactly what md layer is doing.  On failed _read_ it tries to
> reconstruct data from other disk drives and writes the reconstructed
> data back to the drive where read failed.  If the _write_ fails md will
> drop the disk.
Hi Mjt,

I hoped so - great it is implemented like that.

Well, then all that's needed is the check at assembly/creation time:
- (is the drive an ATA-drive) && (does it support SCT ERC)
-> and if it does, set some reasonable timeouts. (like the 7s it is with
enterprise class drives for reading.  For writing I would suggest 14s,
bearing in mind that too quick reallocation results in the spare sectors
running out quickly.)

The writing back (I guess this is done with a reasonable amount of
retries) does not make sense if the drive is still in its error recovery
procedure and does not react to any commands until it is done.

P.S.: I have already implemented the checks and setup, but in userspace
using SG_IO.

/st0ff
>
> /mjt
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

