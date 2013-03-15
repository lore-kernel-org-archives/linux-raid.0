From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Persistent failures with simple md setup
Date: Fri, 15 Mar 2013 23:43:31 +0100
Message-ID: <1407824.2kxT8nEo5d@xrated>
References: <1565063.1kpR7lz4Ph@xrated> <4291349.FrQcKOnicQ@xrated> <20130313115235.01492c21@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130313115235.01492c21@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Mittwoch, 13. M=E4rz 2013, 11:52:35 schrieben Sie:
> hi,
>  wonder if you could try one more test for me.
>  With the other (echo BEFORE / echo AFTER etc) tracing still there, c=
hange
> the /sbin/udevadm settle --timeout=3D$MDADM_DEVICE_TIMEOUT
>  to
>=20
>    /sbin/udevadm --debug settle --timeout=3D$MDADM_DEVICE_TIMEOUT > /=
dev/kmsg
> 2>&1
>=20
>  I found there is a case where "udevadm settle" can exit before the q=
ueue is
> empty.  It seems like a very unlikely scenario, but it seems clear th=
at
> something "unlikely" is happening.
>  I'm hoping to see
>     timeout waiting for udev queue
>=20
>  appear in the logs when this runs.
>=20
>  If you could add that and post the 'dmesg' output if you ever get th=
at
>  message - or maybe even if you don't - that would be very helpful.

Did that right now and disabled the sleep 10 in front, that provisional=
ly=20
"solved" this issue BTW. Now waiting for another md issue to occur.

Cheers,
Pete
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
