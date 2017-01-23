From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Input/Output error reading from a clean raid
Date: Mon, 23 Jan 2017 18:34:11 +0100
Message-ID: <20170123173411.GA9270@metamorpher.de>
References: <CAGmni9p7T5VQsSGQrwkpYgV=H4B-pjXtg8TxnuWst-FQSJh_fA@mail.gmail.com>
 <20170123010334.GA7546@metamorpher.de>
 <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGmni9pazRfia++-s5Hn4FT+ubVzEhsnrQrKC3cSLja53-SizQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 23, 2017 at 11:02:24AM -0300, Salatiel Filho wrote:
> mdadm mdadm --examine-badblocks /dev/sdd1 /dev/sdg1 /dev/sdf1  /dev/sde1
> 
> Bad-blocks on /dev/sdd1:
>           1515723072 for 512 sectors
> Bad-blocks on /dev/sde1:
>           1515723072 for 512 sectors

md believes you have bad blocks in identical places so it won't return 
whatever data is in these blocks. Thus you get read errors even if there 
is no bad block on the disk itself. Those bad block entries can be caused 
by cable or controller flukes, making temporary problems permanent...

Personally I disable the bad block list everywhere.

You can search this list for old messages regarding --examine-badblocks, 
this problem came up several times. Clearing the mdadm bad block list is 
worth a try. There's an undocumented option, update=force-no-bbl or such.

Regards
Andreas Klauer
