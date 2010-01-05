From: fibre raid <fibreraid@gmail.com>
Subject: Re: anybody using the gc-ramdisk?
Date: Mon, 4 Jan 2010 20:34:36 -0800
Message-ID: <5817fbed1001042034s17fcda0cpb6bdcedbaa5cf689@mail.gmail.com>
References: <xuu2aawtfu4c.fsf@nowhere.com>
	 <201001042124.56019.tfjellstrom@shaw.ca>
	 <xuu2vdfhmavg.fsf@nowhere.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <xuu2vdfhmavg.fsf@nowhere.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Megacz <adam@megacz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Adam,

I think you will find that device pretty effective, though I'm not
sure if it will be faster than SSD in real-world scenarios or whether
you will run into other IO bottlenecks elsewhere. You can only
consider PCIe connected SSD drives like SuperTalent's and FusionIO.
though they may actually be more expensive and for your application,
you do not need a lot of space.

-T

On Mon, Jan 4, 2010 at 8:30 PM, Adam Megacz <adam@megacz.com> wrote:
>
> Thomas Fjellstrom <tfjellstrom@shaw.ca> writes:
>> If I had one I might use it as a fs-cache.
>
> I'm not sure it offers any advantage over plain old system RAM in tha=
t
> capacity; I'd be just as well off putting those DIMMs on the
> motherboard.
>
> I can't use plain old system RAM for a journal or a write-intent bitm=
ap
> because system RAM is wiped out in the event of a power failure.
>
> =A0- a
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
