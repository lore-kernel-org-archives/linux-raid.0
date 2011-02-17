From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Re: User space RAID-6 access
Date: Thu, 17 Feb 2011 17:23:32 +1100
Message-ID: <20110217172332.2fbb5694@notabene.brown>
References: <20110131202054.GA15712@lazy.lzy>
	<20110201075259.4beaf501@notabene.brown>
	<20110205173334.GA5952@lazy.lzy>
	<20110206075820.08fc19c9@notabene.brown>
	<20110207222459.GA25471@lazy.lzy>
	<20110208094952.49745c7b@notabene.brown>
	<20110209184734.GA7169@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209184734.GA7169@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Feb 2011 19:47:34 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> > I have applied some patch - with some formatting changes to make it consistent
> > with the rest of the code.
> > 
> > I don't really have time to look more deeply at it at the moment.
> > Maybe someone else will?...
> 
> Hi Neil,
> 
> thanks for including this in git.
> 
> Actually I did it look at it :-) and I already found a
> couple of issues, below is a small fix patch.

Sorry for delay - I have applied this now.


> 
> One question about offsets.
> I noticed that offsets seems to be defined per component,
> in the md software stack.
> I mean, looking at sysfs, the offset are inside md/dev-sdX/offset
> or available with mdadm -E /dev/sdX
> It seems possible that different components have different
> offset (I can imagine this happening with different sizes).
> 
> Now, from inside "test_stripe" there is no information about
> the RAID itself, I mean the device, nor about the metadata type.
> 
> What would be the best way to get the offsets inside "restripe.c"?
> 
> 1) popen "mdadm -E ..." and grep the "Data Offset" field.
> 2) pass one single offset as command line parameter.
> 3) add the whole md device as command line parameter, removing
> the single devices, and use sysfs.

As this is really just for testing, I would add a :offset  suffix to the
device names where the offset is in sectors.
So:
   /dev/sda
means read from the start of /dev/sda

   /dev/sda:2048

means start 1Meg into /dev/sda.

That should be easy to parse and is quite general.

If you wanted to create separate functionality that could be given an active
md device and would read from the component devices, I would link with
sysfs.c and use those routines to read info from sysfs and use that to guide
the code which finds the data.

Make sense?

Thanks,
NeilBrown



> 
> Thanks for any advice,
> 
> bye,
> 
> pg
> 
> 
> diff -uN a/restripe.c b/restripe.c
> --- a/restripe.c	2011-02-09 19:31:18.989495816 +0100
> +++ b/restripe.c	2011-02-09 19:32:42.597955058 +0100
> @@ -430,7 +430,8 @@
>  
>  
>  		if((Px != 0) && (Qx != 0)) {
> -			data_id = (raid6_gflog[Qx] - raid6_gflog[Px]) & 0xFF;
> +			data_id = (raid6_gflog[Qx] - raid6_gflog[Px]);
> +			if(data_id < 0) data_id += 255;
>  			diskD = geo_map(data_id, start/chunk_size,
>  					data_disks + 2, level, layout);
>  			curr_broken_disk = diskD;
> @@ -439,6 +440,9 @@
>  		if((Px == 0) && (Qx == 0))
>  			curr_broken_disk = curr_broken_disk;
>  
> +		if(curr_broken_disk >= data_disks + 2)
> +			broken_status = 2;
> +
>  		switch(broken_status) {
>  		case 0:
>  			if(curr_broken_disk != -1) {
> @@ -450,10 +454,6 @@
>  		case 1:
>  			if(curr_broken_disk != prev_broken_disk)
>  				broken_status = 2;
> -
> -			if(curr_broken_disk >= data_disks + 2)
> -				broken_status = 2;
> -
>  			break;
>  
>  		case 2:
>  
> bye,
> 

