From: Gordon Henderson <gordon@drogon.net>
Subject: Re: So what is the bios doing, if anything ?
Date: Sat, 18 Sep 2004 14:22:29 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0409181413470.32100@lion.drogon.net>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E3C9B@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E3C9B@NZURC900PEX1.ubsgs.ubsgroup.net>
To: peter.greis@ubs.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Sep 2004 peter.greis@ubs.com wrote:

> Greetings,
>
> Still attempting to get a new system built.... which raises a question:
> My mobo has "bios" support for the nVidia nForce3 250Gb and SI 3114. In
> the case of linux, is this doing anything for me ? Do I just ignore it ?
> At present (80GB mirror), the two SATA drives show up as ide3 and ide4.

I did an install on a server which had a plug-in PCI card with a 2-port SI
3112 controller on it with a SATA drives connected. (Is the 311 a 4-port
version of the 3112, I wonder?) The BIOS was no help at all, but I was
able to use the BIOS (on the card) to turn off the on-board mirror
function. I had to do the install to another drive connected to the
on-board standard IDE controller, then put a new kernel on which supports
the SI 3112. (2.4.27 in this case) after that, they appeared as hde and
hdg (ide3 and 4 like yours, I guess)

I used Linux s/w RAID1 on them once I had a kernel and persuaded the BIOS
to boot from them and remove the ordinary IDE drive. Bit dissapointed with
the performance - I could only get ~40MB/sec out of each drive when I'd
expect ~50-55MB/sec out of an ordinary IDE drive these days. MAybe it's
still early days for the driver though.

I haven't spent much time looking into the SATA stuff yet - but it seems
theres 2 camps - one which makes the drives look like IDE drives and one
which makes the look like SCSI.. I did an install on a Dell last week
which I patched in addditional drivers which made the on-board controllers
suddenly switch from a generic IDE interface to SCSI...

> Also, does anyone know what Yast2 (with SuSE 9.1, kernel 2.6.4) is doing
> under the hood during the setup ? Are we really running the md tools or
> not ? Ideas ?

Can't help there I'm afraid - I'm Debian only and haven't even looked at
2.6 yet...

Gordon
