From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Possible failures in raid5?
Date: Wed, 29 Dec 2004 00:40:15 +0100
Message-ID: <vf79a2-pci.ln1@news.it.uc3m.es>
References: <41CF6209.2050209@advocap.org> <qnf7a2-fln.ln1@news.it.uc3m.es> <41D1EB01.1040204@advocap.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle <johnm@advocap.org> wrote:
> If one is using a journaling file system like ext3. Will that fix the 
> problem area?

No. Journalling systems perform no magic - they merely promise that
the file systems they run are consistent, not that they contain the
right data!  They don't and can't compensate for corruptions in the
medium below them.

And the raid system lies below them.

But be careful not to put the journal on the raid system too, if you do
use a journalling file system! That would be extremely nasty.

> My concern was that writes are being done in larger chunks than the 
> written data but possibly that is not a problem.

?? I don't understand what you are saying here.  Writes write what is
written. No more and no less.

Are you referring to the fact that block devices write in units of 1KB
(or other)?  That simply means that in order to write 1B the kernel has
to read 1KB, modify it, then write 1KB back to the device.

> Another issue is it's good to know about any disk failures as soon as 
> possible.

Oh, you will!

> I see someone has suggested running something like
> dd if=/dev/sda of=/dev/null bs=64k

Well that's a read test. You might just as well run e2fsck -c, which
does the same. But it doesn't fix anything, whereas you would fix it if
you simply wrote the block you couldn't read. The drive would fill it
in with a spare.

But why? You can interrogate the disk directly about its condition!
That's what SMART means.

> If one redirects errors to a file will the scsi or ide errors go to the 
> file?

Eh? What do you mean by "an error"? Anyway, whatever you redirect will
go wherever you redirect it to! That's what redirection means.

Peter

