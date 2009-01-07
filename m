From: Tejun Heo <tj@kernel.org>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Wed, 07 Jan 2009 13:59:48 +0900
Message-ID: <496436C4.4070305@kernel.org>
References: <200901032104.15242.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200901032104.15242.bs@q-leap.de>
Sender: linux-ide-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Bernd Schubert wrote:
> But now more than a year has passed again without doing anything
> about it and actually this is what I strongly criticize. Most people
> don't know about issues like that and don't run file checksum tests
> as I now always do before taking a disk into production. So users
> are exposed to known data corruption problems without even being
> warned about it. Usually even backups don't help, since one creates
> a backup of the corrupted data.

sata_sil being one of the most popular controllers && data corruption
reports seem to be concentrated on certain chipsets, I don't think
it's a wide spread problem.  In some cases, the corruption was very
reproducible too.

I think it's something related to setting up the PCI side of things.
There have been hints that incorrect CLS setting was the culprit and I
tried thte combinations but without any success and unfortunately the
problem wasn't reproducible with the hardware I have here.  :-(

Anyways, there was an interesting report that updating the BIOS on the
controller fixed the problem.

  http://bugzilla.kernel.org/show_bug.cgi?id=10480  

Taking "lspci -nnvvvxxx" output of before and after such BIOS update
will shed some light on what's really going on.  Can you please try
that?

> So IMHO, the driver should be deactived for sil3114 until a real
> solution is found. And it only should be possible to force activate
> it by a kernel flag, which then also would print a huuuge warning
> about possible data corruption (unfortunately most distributions
> disables inital kernel messages *grumble*).

The problem is serious but the scope is quite limited and we can't
tell where the problem lies, so I'm not too sure about taking such
drastic measure.  Grumble...

Yeah, I really want to see this long standing problem fixed.  To my
knowledge, this is one of two still open data corruption bugs - the
other one being via putting CDB bytes into burnt CD/DVDs.

So, if you can try the BIOS update thing, please give it a shot.

Thanks.

-- 
tejun
