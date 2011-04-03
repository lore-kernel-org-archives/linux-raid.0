From: Marcus <nexuslite@gmail.com>
Subject: Re: Raid 5 Array
Date: Sun, 3 Apr 2011 01:02:40 -0700
Message-ID: <BANLkTi=yTeG5-E=R6wy0GZe_iyxC5_7-Fg@mail.gmail.com>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
	<AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
	<BANLkTi=wWAE79KOPhZ0OUWpicgcD7QNG-g@mail.gmail.com>
	<BANLkTimRSmSu2XOfQ8yUxn5r2Tsq53LCmQ@mail.gmail.com>
	<BANLkTikQai-ZwuEDQDinMcYi4ics_axd7Q@mail.gmail.com>
	<20110403174900.38de17e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110403174900.38de17e2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, Roman Mamedov <rm@romanrm.ru>, Simon Mcnair <simonmcnair@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The file system is ext4. The current raid drive is 1.5TB the old size
was 1TB. I can create a new partition on the drive it just wont let me
resize it to a larger size. It seems to be maxed out at 1TB for some
reason.

mdstat shows 1465159552 blocks which is the new size.

fdisk -l shows Disk /dev/md2: 1500.3 GB, 1500323381248 bytes 2 heads,
4 sectors/track, 366289888 cylinders.

Current partition: /dev/md2p1              17   244191968   976767808
 83  Linux

resize2fs -p /dev/md2 returns: nothing to do

Nothing is failing it just seems to be at a max size. I also tried
resizing with parted and it seems to think 244191968 is max like
resize2fs does.



On Sun, Apr 3, 2011 at 12:49 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 2 Apr 2011 23:41:50 -0700 Marcus <nexuslite@gmail.com> wrote:
>
>> Okay I have my raid extended to 1500.3GB however I can't seem to grow
>> the partition past 1TB. It will let me create a new partition but it
>> won't let me make the current partition any bigger. Does anyone know
>> how to fix this?
>
> Best to show exactly the command you use, exactly the results, and details
> about the component devices (particularly size).
> When using any mdadm command, add "-vv" to make it as verbose as possible.
> Include kernel log messages (e.g. dmesg | tail -100)
>
> Prefer to send too much info rather than not enough.
> And just place it in-line in the email, no attachments, not 'pastebin' links.
>
> NeilBrown
>
