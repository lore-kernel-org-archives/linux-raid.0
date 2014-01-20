From: den Hoog <speedyden@gmail.com>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Mon, 20 Jan 2014 16:43:38 -0500
Message-ID: <CANgodhBzYbr6+V6POFy5e9cYPtGFYNcfmR2Z8hE5Vj0jA8YveA@mail.gmail.com>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
	<20140106124143.287894da@notabene.brown>
	<CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
	<CANgodhC6wKST5B3zKHD-04xHV8DCUm1Rv71c44RWDMuJp6+WGg@mail.gmail.com>
	<CANgodhDZnogCmXDLz75Hidv=HcYoaoj=1thKTqt8htP8gx3CSw@mail.gmail.com>
	<20140120171645.591b17fc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140120171645.591b17fc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

thanks again for spending time on this when you're already swamped, I
appreciate it much

the commands look logical for my setup (just a type on the chunk size,
needs tobe capital K)
I did not dare to fire off the last command last time, but as missing
seems to be available for imsm, I re-processed all of the commands
again

the Raid0 is created without any trouble (only stating it is already
part of an array, confirmed with Y), but the raid5 array won't.
After it also stated sdc sdd sde are part of an array, and confirming
with Y for the create, it gives the following:

"mdadm: unable to add 'missing' disk to container"
I'm using mdadm - v3.2.6 - 25th October 2012.
Could it be the 3.2.6 does not support missing for imsm?

best regards Dennis


On Mon, Jan 20, 2014 at 1:16 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 16 Jan 2014 22:03:00 +0100 den Hoog <speedyden@gmail.com> wrote:
>
>> Hi Neil
>>
>> can you try to make 'missing' working for imsm?
>>
>> probably not on the short list of things to do, but if you are willing
>> to help me out, I'll appreciate it much!
>
> Hi Dennis,
>
> it seems that "missing" already works with IMSM.  I thought I remembered that
> it didn't, but I was wrong.
>
> So you should be able to create the raid0 using the first parts of the
> devices, then create the RAID5.
> When creating the RAID5, list the devices that should  make up the RAID5 in
> the correct order.
> So something like:
>
>  mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[bcde]
>  mdadm -C /dev/md0 -l0 -n4 -c 128k -z 512G /dev/md/imsm
>  mdadm -C /dev/md1 -l5 -n4 -c 128k missing /dev/sdc /dev/sdd /dev/sde
>
> Then /dev/md1 should be your RAID5 array.
>
> You should double-check the above command to make sure you agree with ever
> part, and ask if there is anything that doesn't seem right.
>
> NeilBrown
>
