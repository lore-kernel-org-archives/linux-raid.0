From: Asdo <asdo@shiftmail.org>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Wed, 27 Jan 2010 10:01:36 +0100
Message-ID: <4B6000F0.2000405@shiftmail.org>
References: <4B5F6C73.30707@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B5F6C73.30707@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:
> This could (and for me did) bring to big disasters!
> Suppose you have a 4 disk raid with 2 spare disk ready for recovery
> There are lot of read errors on disk 1, but md silently recovers them 
> whitout marking disk as faulty (as it did for me)
> Disk 3 fails
> md adds one of the spare disks, and starts resync
> resync fails due to the read errors on disk 1
> everything is lost! till having 2 spare disks!!!???
> This is no fault tollerance ... it's fault creation!!!

Other than monitoring & proactively replacing the disk as Luca suggests, 
the thing that you (probably) have missed is periodically performing scrubs.

See man md for "check" or "repair".

With scrubs, your errors in /dev/sdf and /dev/sdb would have been 
detected long time ago, and the disk in the worst shape would have run 
out of reallocation sectors and be kicked long time ago when the other 
disk was still relatively in good shape.

Double failures (in different positions of different disks) are 
relatively likely if you don't scrub the array. If you scrub the array 
they are much less likely.

That said, you might still be able to get data out of your array:

1 - reassemble it, possibly with --force if normal reassemble refuses to 
work  (*)
2 - immediately stop the resync by writing "idle" on 
/sys/block/mdX/md/sync_action
3 - immediately set it as readonly: mdadm --readonly /dev/sdX
4 - mount the array (w/ readonly mount) and get data out of it with rsyncs

The purpose of 2 and 3 is to stop the resync (your array is not clean). 
I hope one of those two does it. You should not see progress with cat 
/dev/mdstat after those two steps.

#3 also should prevent further resyncs to start, which normally start 
when you hit an unreadable sector. Remember that if the rsync starts, at 
98% of it your array will go down.

Let us know

(*) I don't suggest to use --create and --assume-clean like you did, 
it's much more dangerous than --assemble --force. Was it really needed? 
Really --assemble --force doesn't work?

