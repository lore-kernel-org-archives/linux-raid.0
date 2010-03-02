From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 19:49:40 +0100
Message-ID: <20100302184940.GA2243@lazy.lzy>
References: <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
 <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown>
 <4B853BBF.7000607@tmr.com>
 <yq1ocjemx46.fsf@sermon.lab.mkp.net>
 <20100224185106.GA5426@lazy.lzy>
 <20100225092106.5b7dd6ba@notabene.brown>
 <20100225084141.GA2927@lazy.lzy>
 <20100302155700.68236f28@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100302155700.68236f28@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bill Davidsen <davidsen@tmr.com>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Thanks.  I finally had a look at these (sorry for delay).

well, thank you for having a look at the thing.

> If you run "file" on one of the dumps, it tells you:
> 
> $ file disk1.raw 
> disk1.raw: Minix filesystem
> 
> Which isn't expected.  I would expect something like
> $ file xxx
> xxx: Linux rev 1.0 ext3 filesystem data, UUID=fe55fe6f-0412-4a0a-852d-a0e21767aa35 (needs journal recovery) (large files)
> 
> for an ext3 filesystem.
> 
> Looking at /usr/share/misc/magic, it seems that a Minix filesystem is defined
> by:
> 0x410	leshort		0x137f		Minix filesystem
> 
> i.e. the 2 bytes at 0x410 into the device are 0x137f, which exactly what we
> find in your dump.
> 
> 0x410 in an ext3 superblock is the lower bytes of "s_free_inodes_count", the
> count of free inodes.
> Your actual number is 14881663, which is 0x00E3137F.

Ah! But this means there is a bug somewhere...
 
> So if you just add or remove a file, the number of free inodes should change,
> and your filesystem will no longer look like a Minix filesystem and
> your problems should go away.

Uhm, OK, I just re-created the MD and the FS, so I took
also the opportunity to increase the chunk size to 512K
and use RAID-10.
 
> I guess libblkid et-al should do more sanity checks on the superblock before
> deciding that it really belongs to some particular filesystem.

So, should one of us file a bug report somewhere?

I mean, it is not only (lib)blkid, but also "file"
which seems to be confused.
BTW, "file" does not seem to use libblkid.

> But I'm happy - this clearly isn't a raid problem.

That's certainly good news, thanks again for
the explanation, I learned something today!

bye,

-- 

piergiorgio
