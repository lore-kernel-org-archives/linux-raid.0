From: Neil Brown <neilb@suse.de>
Subject: Re: question : raid bio sector size
Date: Tue, 28 Mar 2006 09:52:56 +1100
Message-ID: <17448.27848.37751.899817@cse.unsw.edu.au>
References: <5d96567b0603270849v6546a760oe3a703cb8bad3b3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Monday March 27
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday March 27, raziebe@gmail.com wrote:
> i have playing with raid5 and i noticed that the arriving bios  sizes
> are 1 sector.
> why is that  and where is it set ?

bios arriving from where?

bios from the filesystem to the raid5 device will be whatever size the
fs wants to make them.

bios from the raid5 device to the component devices will always be 1
page (typically 8 sectors).  This is the size used by the stripe cache
which is used to synchronise everything.

NeilBrown
