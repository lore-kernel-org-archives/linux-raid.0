From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Will mdadm make a backup if it takes two steps to covert raid5 to
 raid6?
Date: Wed, 13 Dec 2017 13:54:57 +0000
Message-ID: <5A313131.9070709@youngman.org.uk>
References: <CAJtTb3EwgaAPCW+xKeNLxViWt2OixTLtW9Zeh3WZQY4q59x6hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJtTb3EwgaAPCW+xKeNLxViWt2OixTLtW9Zeh3WZQY4q59x6hQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Amy Chiang <amychiang@qnap.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/12/17 03:57, Amy Chiang wrote:
> my question is,
> 1. "mdadm --grow /dev/md0 --level=6 --layout=preserve" will this
> command create Q even though it degrades the array?
> 2. Is backup happening in second step (reshaping)? if it's happening,
> why don't I need a backup file?

mdadm normally does not need a backup file. I don't know what
--layout=preserve is doing, but the reshape always happens as an
independent step, even if everything is specified at once.

If the space is available (and mdadm by default always reserves spare
space if it is given enough - I think a 2GB array will trigger a reserve
allocation) a reshape always starts writing in the reserved space. It
will lock and read stripe 1, and write it to reserved space. It will
then lock and read stripe 2, stripe 3 etc until it runs out of reserved
space. It will then use a window to make the new stripes active, unlock
them, and then reserve the space those stripes used to occupy for the
next bit of the reshape.

So, at all times, the bit of the array being reshaped is locked and has
multiple copies, and there's a window setting telling the management
layer where to find the active bits of the array.

Backup files are prone to cause trouble for novices, and this means they
are not necessary. Great news.

Cheers,
Wol
