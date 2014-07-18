From: Killian De Volder <killian.de.volder@megasoft.be>
Subject: Re: Unable to reduce raid size.
Date: Fri, 18 Jul 2014 13:19:11 +0200
Message-ID: <53C902AF.9070404@megasoft.be>
References: <53C8DFEE.7000000@megasoft.be>	<20140718194043.1c938b2c@notabene.brown>	<53C8EFC1.1050105@megasoft.be> <20140718204808.5cbbe0cb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140718204808.5cbbe0cb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Seems to have worked for me. Think I understand what went wrong there.

Thank you, the smaller disk has now been added, and it's rebuilding.

Killian De Volder

On 18-07-14 12:48, NeilBrown wrote:
> On Fri, 18 Jul 2014 11:58:25 +0200 Killian De Volder
> <killian.de.volder@megasoft.be> wrote:
>
>> Bytes are cheap, but screens are small (you'll have to scroll more).
>>
>> "This condition isn't treated as an error by mdadm, so it isn't the cause."
>> This is not an error, but if the size isn't changed, the end result will be
>> component size of /dev/md125 unchanged at 2858285568K (skimmed the source code of mdadm, might have gotten it wrong though)
>>
>> Full Strace below
> Thanks.   It doesn't actually contain any surprises, but having seen it I
> easily found the bug..... hard to explain.
>
> The "SET_ARRAY_INFO" ioctl can be used to set the 'size' of the array, but
> only
> if the size fits in a signed int as a positive number.
> However mdadm tests if it fits in an *unsigned* int.
> So any size between 2^31 and 2^32 K can not effectively be set by mdadm.
>
> I think this patch to mdadm will fix it - can you test?
>
> diff --git a/Grow.c b/Grow.c
> index ea9cc60e1f18..af59347ca75e 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1813,7 +1813,7 @@ int Grow_reshape(char *devname, int fd,
>  		if (s->size == MAX_SIZE)
>  			s->size = 0;
>  		array.size = s->size;
> -		if ((unsigned)array.size != s->size) {
> +		if (array.size != (signed long long)s->size) {
>  			/* got truncated to 32bit, write to
>  			 * component_size instead
>  			 */
>
>
> The code that is reporting an error is setting the used size of each
> individual device.
> If you make the devices in an array bigger (typically if they are LVM volumes
> and you resize them), then you cannot make the array bigger without first
> telling md that the devices have changed size.
> So mdadm first tells the kernel that the devices are big enough.  If they
> were already that big, the kernel will return EBUSY, and mdadm will ignore it.
> If the aren't really that big, the kernel will round down to the real size.
>
> In your case the underlying devices hadn't changed size so mdadm was doing
> something unnecessary and got an error which it ignored.
>
> Thanks,
> NeilBrown
>

