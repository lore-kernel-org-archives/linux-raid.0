From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Wed, 18 Apr 2012 23:53:37 +0300
Message-ID: <CAGRgLy5Mw5yH+hxkmSjPN0kc=rMf168ghQyv95VAL352O68t2A@mail.gmail.com>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<CACVpCE6ZDaGbdfxvfYxe9SHMUrDb5PFuDgNVRLSwWmkRQgmO8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVpCE6ZDaGbdfxvfYxe9SHMUrDb5PFuDgNVRLSwWmkRQgmO8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pawel,
I did not understand that it was a joke (was it???).

Anyways, in our testing, we do a lot of reboots, and array comes up
clean after reboot, even of there's IO on the array at that moment. We
trigger other events to simulate un-clean shutdown of an array. The
problem (in our case), that such event can further cause a drive to
not be available when array comes up. This leads to a dirty-degraded
situation, in which you have to decide whether to wait for a drive to
appear or allow the array to come. That's why I am a bit worried about
this new functionality.

Ales.


On Wed, Apr 18, 2012 at 8:44 PM, Pawe=C5=82 Brodacki
<pawel.brodacki@googlemail.com> wrote:
> 2012/4/18 Alexander Lyakas <alex.bolshoy@gmail.com>:
>> Hi Neil,
>>
>>> This could result in the shutdown happening when array is marked
>>> dirty, thus forcing a resync on reboot. =C2=A0However if you reboot
>>> without performing a "sync" first, you get to keep both halves.
>> Can you pls clarify the last statement?
>>
>> Thanks,
>> =C2=A0Alex.
>
> The RAID array breaks (does not work, because disks are out of sync),
> and you can keep the pieces as a keepsake, I guess :)
>
> By the way. Does it mean, that performing a clean shutdown/boot
> sequence can result in an array requiring a resync? If this is the
> case, could you point me to arguments supporting this change of
> behaviour of shutdown process? I see no obvious reason and crave
> understanding.
>
> Regards,
> Pawe=C5=82
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
