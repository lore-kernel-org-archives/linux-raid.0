From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Bitmap does not account for write errors prior to kicking?
Date: Wed, 15 Jan 2014 19:35:47 +0100
Message-ID: <20140115183547.GA2320@lazy.lzy>
References: <52D6A9DD.7030007@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52D6A9DD.7030007@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 15, 2014 at 04:31:41PM +0100, Ethan Wilson wrote:
[...]
> What do you think about this problem?

Hi Ethan,

I noticed something similar, but I
could not really pin point it.

I've a test RAID-6 made of USB drives.
These drives, being USB, are prone to
leave the array.
So, sometimes, one drive is kicked out.
Having the bitmap active, is no problem
to re-add it back.

Checking the filesystem later, it happens,
sometimes, to find errors.

Now that you point out, it seems a similar
situation. As you wrote is seems the bitmap
is clear before the actual data is written.

Unfortunately, it is difficult (for me) to
reproduce or debug.

bye,

pg

> Thanks
> Ethan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
