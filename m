From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6: Reducing to Grow
Date: Tue, 17 Oct 2017 10:39:56 -0400
Message-ID: <ba94e811-1ae4-a8a3-5907-bde289b44754@turmel.org>
References: <CAPE0SYzB49Vk-QcKWGzVDCqwYjnatGYWrFVeb+jdMF-5wry9Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPE0SYzB49Vk-QcKWGzVDCqwYjnatGYWrFVeb+jdMF-5wry9Lg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Liwei,

On 10/17/2017 01:09 AM, Liwei wrote:
> Hi list, tldr: Have a mixed-sized (2TB and 6TB) RAID6 array, realised
> there is now more potential space (using only 6TB drives) than
> running the array based on the 2TB "smallest-drive" size. Is there a
> way to convert to using only the 6TB drives, without a rebuild?

It depends. /-:

Certainly not in one step.  If you are running LVM on top of your array,
and have the space split up into various LVs, none extremely large,
there are some possibilities.

You might need one more 6TB drive to help with the juggling.

Please use lsdrv[1] to document your running setup so we can see what
might be possible.  Past the output into your reply in *text* mode, with
line wrapping turned off.  (It would help if you composed your mails in
Thunderbird or some client that handles text mode properly -- TBird
supports gmail accounts.)

Phil

[1] https://github.com/pturmel/lsdrv
