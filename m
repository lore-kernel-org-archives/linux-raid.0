From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please help.
Date: Mon, 24 May 2010 14:57:50 -0700
Message-ID: <AANLkTimbLUcCxGwo81HJNFLlrXq9a28j8CNpUcSVlSOr@mail.gmail.com>
References: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinJ2gaVnrPIlJT8m9Ic11qevFNRQgQ-shZropEt@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Reniau <david.reniau@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Way too big and spread out, I don't know if anyone will have the time
to read that.

First, https://raid.wiki.kernel.org/index.php/RAID_Recovery

Second, what parameters do you remember about the original array?

Third, you probably want to try hexdumping the first megabyte or two
of each drive and looking for a superblock of your filesystem.

(man hexdump)

hexdump -Cn $((1024*1024)) /dev/whatever

You may also want to use dd to get the end of the block device.

Most importantly, knowing //where// the superblock is in your device
will allow for a guess about where in to the block-dev the data is
supposed to start.  That ///may/// allow for the creation of a
superblock with the proper alignment (and hopefully chunk size) to
read your data.
