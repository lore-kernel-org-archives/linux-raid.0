From: Jaap Winius <jwinius@umrk.nl>
Subject: Re: Can this array be recovered?
Date: Tue, 25 Dec 2012 15:24:23 +0000 (UTC)
Message-ID: <kbcgf7$ste$1@ger.gmane.org>
References: <kbb975$nj1$1@ger.gmane.org> <50D9422F.9010403@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Dec 2012 01:05:35 -0500, Phil Turmel wrote:

> Stop the array.  Create it again, but specify v0.90 or v1.0 metadata.
> (v1.0 also puts the superblock at the end.)

Okay, I used this command:

# mdadm --create /dev/md1 --metadata=0.90 --level=1 --raid-devices=2 /dev/
sd[ef]2
 
> Since v1.2 metadata skips the first 4k, the critical part of the LVM
> metadata is probably intact, and it'll "just work".

I like that you're so optimistic, but unfortunately pvscan still doesn't 
see anything on /dev/md1 and now also mentions "Incorrect metadata area 
header checksum" when run.

> After you recover your data, you should consider rebuilding your array
> with default (v1.2) metadata for everything other than your boot
> filesystem.

If I manage to get my array back, I will definitely give that a try.

Christmas cheers,

Jaap

