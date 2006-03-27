From: Jens Axboe <axboe@suse.de>
Subject: Re: raid and elevator
Date: Mon, 27 Mar 2006 14:44:47 +0200
Message-ID: <20060327124447.GM8186@suse.de>
References: <5d96567b0603261329o39a5e777w5bc39ad5251b4ecb@mail.gmail.com> <20060327122747.GK8186@suse.de> <5d96567b0603270436x69eba93cx4b55b942c422afe0@mail.gmail.com> <20060327123951.GL8186@suse.de> <5d96567b0603270442t190156d9x54102230e63b85c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5d96567b0603270442t190156d9x54102230e63b85c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Once again, don't top post. Please!

On Mon, Mar 27 2006, Raz Ben-Jehuda(caro) wrote:
> i am sending 1MB buffer to a raid of 1MB chunk size.
> i know that each offset is aligned by the chunk size.

The raid is limited by the hardware storage, as the bio units are
essentially (usually) passed further down the stack untouched.

-- 
Jens Axboe

