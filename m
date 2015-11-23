From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Mon, 23 Nov 2015 15:47:40 +0000
Message-ID: <5653351C.7070302@youngman.org.uk>
References: <189791448292518@web28m.yandex.ru>
 <2542241448292944@web16h.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2542241448292944@web16h.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Semyon Enskiy <semyon.enskiy@yandex.ru>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/11/15 15:35, Semyon Enskiy wrote:
> /
> Seems, that I should write data back to source block device to do it
> consistent and able to recreate array with one corrupted device, reboot,
> recreate array, resync faulty device.
> /
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Something I couldn't work out from your post - what are your drives? Are
they proper raid drives, or desktop drives? Is SCTERC (think that's what
it's called) enabled and functioning?

I won't be able to help beyond that, but the experts will want that info...

smartctl -x

Cheers,
Wol
