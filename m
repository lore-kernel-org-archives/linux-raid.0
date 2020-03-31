From: antlists <antlists@youngman.org.uk>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Tue, 31 Mar 2020 01:24:43 +0100
Message-ID: <058b3f48-e69d-2783-8e08-693ad27693f6@youngman.org.uk>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Jones <dj@iowni.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/03/2020 01:04, Daniel Jones wrote:
> I am genuinely over my head at this point and unsure how to proceed.
> My logic tells me the best choice is to attempt a --create to try to
> rebuild the missing superblocks, but I'm not clear if I should try
> devices=4 (the true size of the array) or devices=3 (the size it was
> last operating in).  I'm also not sure of what device order to use
> since I have likely scrambled /dev/sd[bcde] and am concerned about
> what happens when I bring the previously disable drive back into the
> array.

Don't even THINK of --create until the experts have chimed in !!!

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

The lsdrv information is crucial - that recovers pretty much all the 
config information that is available, and massively increases the 
chances of a successful --create, if you do have to go down that route...

If your drives are 1TB, I would *seriously* consider getting hold of a 
4TB drive - they're not expensive - to make a backup. And read up on 
overlays.

Hopefully we can recover your data without too much grief, but this will 
all help.

Cheers,
Wol
