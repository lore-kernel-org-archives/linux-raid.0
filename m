From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Tue, 2 Feb 2010 09:07:31 -0500
Message-ID: <7c2a12e21002020607j38d35a1bq85d37221b922da0f@mail.gmail.com>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
	 <72dbd3151002011310g57fa9b66j2798aa0acde199b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3151002011310g57fa9b66j2798aa0acde199b2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Wil Reichert <wil.reichert@gmail.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 1, 2010 at 4:10 PM, David Rees <drees76@gmail.com> wrote:
> I suspect that if you used write-behind with a write-intent bitmap
> stored only on the SSD, you'd get some of that performance back, but
> potentially lose a bit of reliability.

You'd only lose data here if the SSD died and the machine crashed *at
the same time*, right?  Doesn't seem like a big deal to me -- if the
events are even a minute or two apart, you'd be fine (right?).  By
contrast, if I understand correctly, you can get data corruption in
RAID5 if you lose a disk and then the machine crashes *any* time
before a new disk is resynced.
