From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: want_replacement (aka --replace)
Date: Sat, 27 Apr 2013 09:04:59 +0200
Message-ID: <20130427070459.GA2246@lazy.lzy>
References: <glsr4axsi2.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <glsr4axsi2.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Keith,

On Fri, Apr 26, 2013 at 08:18:40PM -0700, Keith Keller wrote:
> Hi all,
> 
> For other reasons I moved one of my md servers to kernel 3.8, and on a
> whim I decided to test --replace on a RAID6 array.  For this test I used
> mdadm from Neil's git repository, but from a read of the md kernel
> documentation you could probably do this just from manipulating
> /sys/block/mdN/md/ appropriately if you don't or can't get the latest
> mdadm.
> 
> It went very smoothly in my test.  I marked one drive with --replace,
> and the array started rebuilding with the new drive, without any IO from
> the other members of the array.  It took much less time than a full
> rebuild, and when it was done, the old drive was marked faulty, as
> expected.
> 
> This is really an amazing feature!  I can see at least two use cases for
> it:
> 
> ==you suspect a drive is failing but it hasn't been kicked yet
> ==you want to replace all the drives with larger drives in order to grow
> the array
> 
> Are there any other use cases?  In the scenario where the drive marked

my further idea would be to "rotate" a spare,
so that the different HDDs will have, in the
end, different power on hours.
Of course, the spare must be idle while not
in use.

bye,

pg

> as wanting replacement fails completely, does md fall back to a full
> rebuild with the new drive?  Can it pick up in the middle or does it
> have to start over?
> 
> Thanks to Neil and the other md developers for such a great feature.
> 
> --keith
> 
> -- 
> kkeller@wombat.san-francisco.ca.us
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
