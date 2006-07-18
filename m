From: Neil Brown <neilb@suse.de>
Subject: Re: PLEASE HELP ... raid5 array degraded ...
Date: Tue, 18 Jul 2006 12:20:19 +1000
Message-ID: <17596.17763.497553.858996@cse.unsw.edu.au>
References: <51adc5d50607112009v476d680fqe9918d607b90def4@mail.gmail.com>
	<51adc5d50607112016u428b48efx335dc704bb91dfb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Skolarz on Tuesday July 11
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Skolarz <pletopia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 11, pletopia@gmail.com wrote:
>        Checksum : 4aa9094a - expected 4aa908c4

This is a bit scary.  You have a single-bit error, either in the
checksum or elsewhere in the superblock.

I would recommend at least a memtest86 run.

NeilBrown


