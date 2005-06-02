From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Is there a drive error "retry" parameter?
Date: Thu, 02 Jun 2005 21:16:05 +0400
Message-ID: <429F3ED5.4020005@tls.msk.ru>
References: <200505021224.35396.mlaks@verizon.net> <429F2458.6070404@update.fsix.com>
Reply-To: linux-raid@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429F2458.6070404@update.fsix.com>
Sender: linux-raid-owner@vger.kernel.org
To: cknowlton@science.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Knowlton wrote:
> I want to understand exactly what is going on in the Software RAID 5
> code when a drive is marked "dirty", and booted from the array.  Based
> on what I've read so far, it seems that this happens any time the RAID
> software runs into a read or write error that might have been corrected
> by fsck (if it had been there first).  Is this true?

You're mixing up 2 very different things here.  Very different.

Fsck has nothing to do with raid, per se.  Fsck checks the filesystem
which is on top of a block device (be it a raid array, a disk, or a
loopback device, whatever).  It does not understand/know what is "raid",
at all.  Speaking of raid, the filesystem is an upper-level stuff.  Again,
raid code knows nothing about filesystems or any data it stores.  Also,
filesystem obviously does not know about underlying components of the
raid array where the filesystem resides -- so fsck can NOT "fix" whatever
error happened two layers down the stack (fs, raid, underlying devices).

From the other side, raid code ensures (or tries to, anyway) that any
errors in underlying (components) devices will not propagate to the
upper level (be it a filesystem, database or anything else - raid does
not care what data it stores).  It is here to "hide" whatever errors
may happen on the physical device (disk drive).  Currently, if enouth
drives fails, raid array will be "shut down" so that the upper level
(eg filesystem) can't even access the whole raid array.  Until that
happens, there should be no errors propagated to the filesystem layer,
all such errors will be corrected by raid code, ensuring that it will
read the same data as has been written to it.

> Is there a "retry" parameter that can be set in the kernel parameters,
> or else in the code itself to prolong the existence of a drive in an
> array before it is considered dirty?

There's no such parameter currently.  But there was several discussions
about how to make raid code more robust - in particular, in case of
read error, raid code may keep the errored drive in the array and mark
it dirty only in case of write error.

> If so, I would like to increase it in my environment, because it seems
> like I'm losing drives in my array that are often still quite stable.

I think you have to provide some more information.  Kernel logging tells
alot of details about what exactly happening and what the raid code is
doing as a result of that.

Raid code is quite stable and is used in alot of machines all over the
world.  If you're expiriencing such a weird behaviour, I think it's due
to some othe problem on your side, and the best would be to find and fix
the real error, not the symptom.

/mjt
