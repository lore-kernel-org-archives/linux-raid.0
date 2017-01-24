From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Input/Output error reading from a clean raid
Date: Tue, 24 Jan 2017 21:58:56 +0000
Message-ID: <5887CE20.1020606@youngman.org.uk>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
 <20170123010334.GA7546@metamorpher.de>
 <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
 <20170123173411.GA9270@metamorpher.de>
 <CAGmni9qF_LjdzYtsMJ9YmHoymG=SN6p2Mta-COEhbyReQFbNTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9qF_LjdzYtsMJ9YmHoymG=SN6p2Mta-COEhbyReQFbNTA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/01/17 21:15, Salatiel Filho wrote:
> I really think it is very unlikely that two different disks from two
> different brands would have problems at exactly the same block.
> I have a question, who populates the badblock list ? Is the check
> action send to the /sys/block/md??/md/sync_action OR each read error
> updates it ?

I think it's a known problem - nobody seems to know quite why it happens
but when a block is added to the badblocks list it seems to get added to
every device. Given that modern hard-drives are supposed to relocate bad
blocks and not need a badblock list, I think that's why it's not been
found, most people especially those in the know just tend to disable
os-level badblocks.

Cheers,
Wol
