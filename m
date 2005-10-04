From: Neil Brown <neilb@suse.de>
Subject: Re: non-fresh drive?
Date: Tue, 4 Oct 2005 10:10:42 +1000
Message-ID: <17217.51330.226993.899160@cse.unsw.edu.au>
References: <750072490510020810v72a97793m32e4835c36bb0289@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hank Barta on Sunday October 2
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 2, hbarta@gmail.com wrote:
> I have a 5 disk raid that is currently using only 4 disks. On startup,
> it rejects an apparently good drive with the message that it is
> non-fresh. I don;t understand what non-fresh means nor how to resolve
> this.

'non-fresh' means that it doesn't seem to up-to-date with respect to
the other drives in the array.
Use "mdadm --examine /dev/sda1" and compare that with
"mdadm --examine /dev/sdc1" to see what the difference is.  It is
probably the Event count.

To re-incorporate sda1 into the array, use
  mdadm /dev/md0 -a /dev/sda1

NeilBrown
