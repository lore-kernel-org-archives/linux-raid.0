From: Billy Crook <billycrook@gmail.com>
Subject: Re: mdadm freezes the system
Date: Wed, 16 Jun 2010 06:47:00 -0500
Message-ID: <AANLkTin9w6CCjNXuZ60g3ncdD82mqgKXf5StGMOIiZzL@mail.gmail.com>
References: <20100608145913.187a69ca@natsu> <20100608222434.3f0fb637@natsu>
	<20100611004316.7d8ad74d@natsu> <AANLkTikdknJnRpHrMybjFTFDRHTH9ad4Rne_wyQ_-84s@mail.gmail.com>
	<20100616131609.477fcca8@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616131609.477fcca8@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 16, 2010 at 02:16, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Wed, 16 Jun 2010 00:03:54 -0700
> Michael Evans <mjevans1983@gmail.com> wrote:
>
>> Have you exhaustively tested your drives as well?
>>
>> The smartctl -t long test is a good one to start with.

smartctl -t short /dev/sdX ; sleep 120; smartctl -t conveyance

Most smart failures I've seen fail the short test, and it only takes
two minutes.  Conveyance isn't much longer.  If either test actually
fails (not just gets interrupted), RMA it.

> I run that the first thing after buying every new disk. The drives are okay,
> even if they weren't, they should absolutely not cause the system lock-up in
> the manner I was experiencing.

Slightly off topic, but I wrote a script I thought I'd share, which I
use on all new drives.  It takes its time depending on how fast a
sustained read/write speed the drive has, but it only takes a couple
seconds to begin.
http://www.kclug.org/wiki/index.php/Hard_Drive_Hell
