From: Matthew Bloch <matthew@bytemark.co.uk>
Subject: Nearest mdadm equivalent of kernel RAID autostart code?
Date: Fri, 21 Jan 2005 16:22:21 +0000
Message-ID: <csra7t$21h$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

After a lot of compiling static kernels, I'm building a generic one for our
particular mix of servers, so the md code is now modular.  I didn't realise
that I'd lose the automatic array assembly functionality, though I
appreciate reasons for trying to deprecate it.

Can anyone suggest a better shell equivalent of the array assembly
functionality that I can use with a modular md?  So far I've got:

for DEV in 0 1 2 3 4 5 6 7 ; do
  mdadm -Ac partitions -m $DEV /dev/md$DEV
done

But this seems a bit slow as it tears through every device in /dev on each
call (about 30 seconds per mdadm call).  I don't want to have RAID
configuration files on each server if I can avoid it, as I know that all
the info I need will be in the relevant discs' superblocks.

Any better ideas for doing the job?

-- 
Matthew Bloch                             Bytemark Hosting
                                http://www.bytemark.co.uk/
                phone UK: 0845 004 3 004 US: 1-877 BYTEMAR
          Dedicated Linux hosts from 15ukp ($26) per month

