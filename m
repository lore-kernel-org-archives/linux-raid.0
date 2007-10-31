From: Kyle Stuart <kstuart@sisna.com>
Subject: Re: Bad drive discovered during raid5 reshape
Date: Tue, 30 Oct 2007 18:08:18 -0600
Message-ID: <4727C772.6050301@sisna.com>
References: <47258776.9020601@sisna.com>	<18214.53051.652280.492087@notabene.brown>	<472712E5.10806@dgreaves.com> <18215.6378.912706.274201@notabene.brown> <4727251E.5030705@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4727251E.5030705@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> I read that he aborted it, then removed both drives before giving md a chance to
> restart.
>
> He said:
> After several minutes dmesg indicated that mdadm gave up and
> the grow process stopped. After googling around I tried the solutions
> that seemed most likely to work, including removing the new drives with
> mdadm --remove --force /dev/md1 /dev/sd[bc]1 and rebooting
>
> and *then* he: "ran mdadm -Af /dev/md1."
>   
This is correct. I first removed sdb and sdc then rebooted and ran mdadm
-Af /dev/md1.
>
> Kyle - I think you need to clarify this as it may not be too bad. Apologies if I
> misread something and sdc is bad too :)
>
> It may be an idea to let us (Neil) know what you've done and if you've done any
> writes to any devices before trying this assemble.
>
> David
When I sent the first email I thought only sdb had failed. After digging
into the log files it appears sdc also reported several bad blocks
during the grow. This is what I get for not testing cheap refurbed
drives before trusting them with my data, but hindsight is 20/20.
Fortunately all of the important data is backed up so if I can't recover
anything using Neil's suggestions it's not a total loss.

Thank you both for the help.
