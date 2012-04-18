From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Wed, 18 Apr 2012 19:44:11 +0200
Message-ID: <CACVpCE6ZDaGbdfxvfYxe9SHMUrDb5PFuDgNVRLSwWmkRQgmO8Q@mail.gmail.com>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/4/18 Alexander Lyakas <alex.bolshoy@gmail.com>:
> Hi Neil,
>
>> This could result in the shutdown happening when array is marked
>> dirty, thus forcing a resync on reboot. =C2=A0However if you reboot
>> without performing a "sync" first, you get to keep both halves.
> Can you pls clarify the last statement?
>
> Thanks,
> =C2=A0Alex.

The RAID array breaks (does not work, because disks are out of sync),
and you can keep the pieces as a keepsake, I guess :)

By the way. Does it mean, that performing a clean shutdown/boot
sequence can result in an array requiring a resync? If this is the
case, could you point me to arguments supporting this change of
behaviour of shutdown process? I see no obvious reason and crave
understanding.

Regards,
Pawe=C5=82
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
