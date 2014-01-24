From: den Hoog <speedyden@gmail.com>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Fri, 24 Jan 2014 18:13:29 -0500
Message-ID: <CANgodhDN6zM9UA5ZoFLGGsry4EsFK67ni3w+p+YEFny8YQdCYw@mail.gmail.com>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
	<20140106124143.287894da@notabene.brown>
	<CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
	<CANgodhC6wKST5B3zKHD-04xHV8DCUm1Rv71c44RWDMuJp6+WGg@mail.gmail.com>
	<CANgodhDZnogCmXDLz75Hidv=HcYoaoj=1thKTqt8htP8gx3CSw@mail.gmail.com>
	<20140120171645.591b17fc@notabene.brown>
	<CANgodhBzYbr6+V6POFy5e9cYPtGFYNcfmR2Z8hE5Vj0jA8YveA@mail.gmail.com>
	<20140121091144.4873d3ec@notabene.brown>
	<20140121095129.5d5d7f8b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121095129.5d5d7f8b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks for your effort Neil!
sorry for the delay, could not free serious time to do this thoroughly.

Ok, I pathced mdadm, did a make after the git, and ended up with a
brand new v3.3-55 23-Jan 2014

After the command review I started executing them, but after the
creation of the container I had a PSU failure.....
long story short, booted again, did the same, and created the 3 device
container and gave the following
" mdadm: container /dev/md/imsm prepared."

after that I tried to create the first raid5 with missing, It gave the message:
"mdadm: largest drive (/dev/sdc) exceeds size (536870912K) by more than 1%"
but continued creating the array
"mdadm: Creating array inside imsm container md127
mdadm: internal bitmaps not supported with imsm metadata"

I stopped the md127, re issued the command and got the following:
"mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started."

so far so good. I examined the array and found the used device to be
slightly less than the original raid0 volume:
Used Dev Size : 1073741824 (512.00 GiB 549.76 GB)

Hoping for the best I created the next raid5 volume, and got the following:
"mdadm: cannot open /dev/sdc: Device or resource busy"

so I stopped the md0, and re-issued the command for the 2nd L5 volume again.
"mdadm: array /dev/md1 started."

After examining the array again, I discovered that it did not put it
after md0, but created a L5 array at full capacity:
 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 11720662272 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774848 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors

did an mdstat, but it did not appear to be doing anything, no resync ,
fortunately
"md1 : active raid5 sde[3] sdd[2] sdc[1]"

I reset it all again, with only the container again, but I figure that
although it did not start a resync, it does not look very promising

If you can find a minute and tell me where I went wrong, and if you
still think it is worth giving it another try?

If all is lost, I have to live with an old partial backup I have, but
we gave it a try ;)

thanks again, Dennis






On Mon, Jan 20, 2014 at 5:51 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 21 Jan 2014 09:11:44 +1100 NeilBrown <neilb@suse.de> wrote:
>
>> On Mon, 20 Jan 2014 16:43:38 -0500 den Hoog <speedyden@gmail.com> wrote:
>>
>> > Hello Neil,
>> >
>> > thanks again for spending time on this when you're already swamped, I
>> > appreciate it much
>> >
>> > the commands look logical for my setup (just a type on the chunk size,
>> > needs tobe capital K)
>> > I did not dare to fire off the last command last time, but as missing
>> > seems to be available for imsm, I re-processed all of the commands
>> > again
>> >
>> > the Raid0 is created without any trouble (only stating it is already
>> > part of an array, confirmed with Y), but the raid5 array won't.
>> > After it also stated sdc sdd sde are part of an array, and confirming
>> > with Y for the create, it gives the following:
>> >
>> > "mdadm: unable to add 'missing' disk to container"
>> > I'm using mdadm - v3.2.6 - 25th October 2012.
>> > Could it be the 3.2.6 does not support missing for imsm?
>>
>> That's weird.  I'm sure I tested it yesterday and it worked.
>> Today it doesn't in exactly the way you describe.
>> I'll have a poke and see what is happening.
>
> OK I think I figured it out.
>
> Firstly, to create an IMSM array with a missing device, every array in the
> container must have the same device missing.
> Now you cannot create the RAID0 with a missing device, so you need to create
> a RAID5 in it's place instead.
> So:
>
>   mdadm -C /dev/md/imsm -e imsm -n 3 /dev/sd[cde]
>   mdadm -C /dev/md0 -l 5 -n 4 -c 128K -z 512G missing /dev/sd[cde]
>
> then create the radi5 you want:
>
>   mdadm -C /dev/md1 -l 5 -n 4 -c 128K missing /dev/sd[cde]
>
> That creates the container with 3 devices, and two 4-device arrays each with
> one device missing (every array in a container must have the same number of
> devices, and must have the same number that are missing).
>
> However the above will crash.  That is the "secondly".
>
> You need the following patch, or you can just collect the latest from
> git://neil.brown.name/mdadm/
>
> NeilBrown
>
> commit 1ca5c8e0c74946f4fcd74e97c5f48fba482d9596
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Jan 21 09:40:02 2014 +1100
>
>     IMSM: don't crash when creating an array with missing devices.
>
>     'missing' devices are in a different list so when collection the
>     serial numbers of all devices we need to check both lists.
>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/super-intel.c b/super-intel.c
> index c103ffdd2dd8..f0a7ab5ccc7a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5210,6 +5210,8 @@ static int create_array(struct supertype *st, int dev_idx)
>                 int idx = get_imsm_disk_idx(dev, i, MAP_X);
>
>                 disk = get_imsm_disk(super, idx);
> +               if (!disk)
> +                       disk = get_imsm_missing(super, idx);
>                 serialcpy(inf[i].serial, disk->serial);
>         }
>         append_metadata_update(st, u, len);
