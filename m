From: Hank Barta <hbarta@gmail.com>
Subject: Re: non-fresh drive?
Date: Tue, 4 Oct 2005 07:52:33 -0500
Message-ID: <750072490510040552l4e9052c6s7104a8fcf574a295@mail.gmail.com>
References: <750072490510020810v72a97793m32e4835c36bb0289@mail.gmail.com>
	 <17217.51330.226993.899160@cse.unsw.edu.au>
Reply-To: Hank Barta <hbarta@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17217.51330.226993.899160@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/3/05, Neil Brown <neilb@suse.de> wrote:
> On Sunday October 2, hbarta@gmail.com wrote:
> > I have a 5 disk raid that is currently using only 4 disks. On startup,
> > it rejects an apparently good drive with the message that it is
> > non-fresh. I don;t understand what non-fresh means nor how to resolve
> > this.
>
> 'non-fresh' means that it doesn't seem to up-to-date with respect to
> the other drives in the array.
> Use "mdadm --examine /dev/sda1" and compare that with
> "mdadm --examine /dev/sdc1" to see what the difference is.  It is
> probably the Event count.
>
> To re-incorporate sda1 into the array, use
>  mdadm /dev/md0 -a /dev/sda1

Yes, thanks. Another list member replied privately and helped me sort
this out (except for the --examine part.) It's running on all 5 drives
again but I'm still puzzled why the one became non-fresh. I'll have to
watch it more closely.

thanks,
hank

--
Beautiful Sunny Winfield, Illinois
