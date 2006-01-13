From: Neil Brown <neilb@suse.de>
Subject: Re: "too small for md"
Date: Fri, 13 Jan 2006 16:01:02 +1100
Message-ID: <17351.13326.363637.158332@cse.unsw.edu.au>
References: <c571c4540601122053o5ea8224dq3676fb51f19bca22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jared Johnson on Thursday January 12
Sender: linux-raid-owner@vger.kernel.org
To: Jared Johnson <spongebobsquarehat@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 12, spongebobsquarehat@gmail.com wrote:
> hi,
> 
> I created a raid5 array with 6 parts but one "missing", thus with 5
> drives.  I stuck some data on it and all was well.  I rebooted and it
> didn't exist.  I think I needed to add something to mdadm.conf or
> whatnot, but anyway.  I tried to manually assemble it but it told me
> that one of the drives had no superblock. I did mdadm --examine
> /dev/hda2 (the partition in question) and it tells me:
> 
> mdadm: /dev/hda2 is too small for md.
> 
> I don't really understand superblocks at all.  I google'd around and
> saw some suggestions that such things might be caused by corrupt
> superblocks, really very little information though.  Since my data is
> backed up, I decided to try mdadm --zero-superblock /dev/hda2 althogh
> I am not sure whether that will just certainly break things.  I get
> the same "too small for md".  I tried everything with --force as well
> with no change.  The partition in question, btw, is 220GB.
> 
> Any ideas?

You didn't say what version of mdadm you are using.
Can you tell us, and all run

   strace mdadm --examine /dev/hda2

and send the output.

Thanks,
NeilBrown


