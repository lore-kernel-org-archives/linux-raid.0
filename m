From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Detecting array parameters
Date: Sat, 12 Jun 2010 11:58:21 +0200
Message-ID: <20100612095821.GA14727@lazy.lzy>
References: <20100609211340.GA12172@lazy.lzy>
 <20100610083112.47aa2200@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100610083112.47aa2200@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the answer.

The "--export" option is a good advice, unfortunately
it seems to be quite "conservative" in the amount of
information, probably it is following some "udev"
requirements, I guess.

I'll try to explain what I'm trying to do, so, maybe,
there will be some other good advices.

I've a bunch (10) of different (in size too) HDDs.
These HDDs are partitioned in a way so that equal
partitions can compose several RAID-6 arrays.
So, for example, there are 5x 120GB and 5x 80GB HDDs.
The firsts are partitioned in 80+40, and there are 2
RAID-6, one made of 10 80GB "segments" and another
made of 5 40GB "segments".
So far, so good.

What I would like to do is a script, which, given an
HDD as parameter will *properly* add it to the array.
Where *properly* means, it will partition it properly,
add the partitions to the respectively arrays, and
perform, if necessary (non-degraded case) a grow.

My idea would be to go over the several arrays, check
the partition size, create a partition on the new HDD,
if possible, then add it and grow the array (if required).

The first step would be to find out the partition size,
which does seem to be avaialable in:

/sys/class/block/mdX/md/rdX/block/size

I was wondering if this would be the best option to get
this information, or there are better solutions.

Trying "mdadm -E /dev/sdX" returns also similar information,
namely the available device size and the offset, which sum
up to the partition size.

In /sys/class/block/mdX/md/rdX there are also two files,
carrying similar information: "size" and "offset".
In this case, strangely, the size is in KiB while the
offset in sectors (seems a bug to me).

Any suggestions on how to do this in a *correct* way?

Thanks a lot in advance for any advice and, please,
feel free to ask if you need more information.

bye,

pg

On Thu, Jun 10, 2010 at 08:31:12AM +1000, Neil Brown wrote:
> On Wed, 9 Jun 2010 23:13:40 +0200
> Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi,
> > 
> > if I understood it correctly, in order to detect
> > the several array parameters (number of disks, for
> > example), it is possible to use "mdadm -D /dev/mdX"
> > or to check the files in the corresponding /sys/block/...
> > /mdX/... files.
> > 
> > Now, assuming something needs to be done in scripts,
> > what would be the best way? Using "mdadm -D ... | grep"
> > (or "mdadm ... | gawk ...."), or to read the proper
> > files in /sys/block/md...?
> > 
> > Assuming the wanted information is available on both
> > sides, which does not seem always the case.
> 
> If it is available in 
>    mdadm --detail --export
> 
> I would use that.
> Otherwise probably go for
>    /sys/class/block/mdX/md/...
> 
> I say /sys/class/block rather than /sys/block as there are rumours of
> deprecating /sys/block.  Don't know if that will ever happen though.
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
