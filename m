From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Thu, 21 May 2020 09:09:41 +0100
Message-ID: <5EC63745.1080602@youngman.org.uk>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk> <20200520235347.GF1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200520235347.GF1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
Cc: Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

On 21/05/20 00:53, David T-G wrote:
>   ## parted
>   Model: ATA ST4000DM000-1F21 (scsi)
>   Disk /dev/sdd: 4001GB
>   ## Version
>   Firmware Version: CC54
>   ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
>   SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
>   SCT capabilities:              (0x1085) SCT Status supported.
>   SMART Error Log Version: 1
>   ## scterc
>   SCT Error Recovery Control command not supported
> 
> Curiously, note that querying just scterc as the wiki instructs says "not
> supported", but a general smartctl query says yes.  I'm not sure how to
> interpret this...

Seagate Barracudas :-(

As for smartctl, you're asking two different things. Firstly is SCT
supported (yes). Secondly, is the ERC feature supported (no).

And that second question is the killer. Your drives do not support error
recovery. Plan to replace them with ones that do ASAP!

I'm currently running on two 3TB Barracudas mirrored. I've finally got
around to building a system with two 4TB Ironwolves to replace them. You
need to think about the same.

In the meantime, make sure you're running Brad's script, and watch out
for any hint of lengthening read/write times. That's unlikely to be why
your overlay drives won't mount - I suspect a problem with loopback, but
I don't know.

What I don't want to advise, but I strongly suspect will work, is to
force-assemble the two good drives and the nearly-good drive. Because it
has no redundancy it won't scramble your data because it can't do a
rebuild, but I would VERY STRONGLY suggest you download lsdrv and get
the output. The whole point of this script is to get the information you
need so that if everything does go pear shaped, you can rebuild the
metadata from first principles. It's easy - git clone, run.

Cheers,
Wol
