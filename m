From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 mounting problem
Date: Fri, 21 Feb 2003 11:04:54 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15957.27942.943883.83757@notabene.cse.unsw.edu.au>
References: <20030220080959.GA22919@cce.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sedlak Anton on Thursday February 20
To: Sedlak Anton <ased@cce.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 20, ased@cce.cz wrote:
> We have raid1 array of /dev/hda1 and /dev/hdc1.
> It looks that it is possible to mount /dev/hda1 and /dev/hdc1 in the
> same time when raid1 is active.
> Is such behavior correct ?
> If not why it is allowed ?

It would be unwise to do this.
In 2.4 there is no mechanisim to stop the mounting of a device that is
in-use.
In 2.5 there is.  You will find that it is not possible to do this
with 2.5/2.6.

NeilBrown
