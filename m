From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid array with 3T disks and GPT partition
Date: Wed, 25 Jan 2012 11:15:26 +0000
Message-ID: <20255.58446.978866.969959@tree.ty.sabi.co.UK>
References: <20110901154759.GA32649@apartia.fr>
	<20110901155913.GA20825@cthulhu.home.robinhill.me.uk>
	<20110901163334.GA13347@apartia.fr>
	<4E5FB8EC.5040801@redhat.com>
	<4F0C9423.6000201@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0C9423.6000201@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> Non-FS Data, which we hijacked for our purposes as it will
>> keep the system (any OS in fact) from thinking there should
>> be a filesystem there, leaving it free for us to pick up
>> anytime in the boot process.

> What do you mean?  Linux doesn't care what the partition type
> code says. I brought that up on lkml a year or so back that
> it should at least respect the hidden flag and not expose that
> partition, but nobody seemed interested.

Probably you were posting to the wrong mailing list, as 'Linux'
(the kernel) indeed does not and should not care about the
partition type code, because all it does is to enumerate
partitions reading them from the label (if any) wrapping them as
block-devices, and the only filetree that 'Linux' mounts is the
'/' one in the block-device that is explicitly indicated (in the
kernel image or at boot).

Automounting, if any, is done by system or user daemons and the
logic (and whether the 'hidden' flag is respected) they follow is
distribution specific. LKML is not where that should be discussed.

The only case where partition types matter to the kernel is for
auto-detection of RAID members, but that is somewhat obsolete as
the man-page says:

http://linux.die.net/man/8/mdadm
 =ABIn-kernel autodetect is not recommended for new installations.
  Using mdadm to detect and assemble arrays - possibly in an
  initrd - is substantially more flexible and should be preferred.=BB

And even as to the '/' filetree, in general 'Linux' nowadays in
most distros boots only from an 'initrd' and even mounting the '/'
filesystem is done from the 'initrd', and any rules about mounting
which block-devices in the 'initrd' or later in some automount
daemon configuration.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
