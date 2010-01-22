From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Fri, 22 Jan 2010 17:37:00 +0100
Message-ID: <87bpgmyu37.fsf@frosties.localdomain>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
	<20100109192326.GB16383@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100109192326.GB16383@rap.rap.dk> (Keld Jorn Simonsen's message
	of "Sat, 9 Jan 2010 21:23:26 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Keld Jorn Simonsen <keld@keldix.com>
Cc: Wil Reichert <wil.reichert@gmail.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen <keld@keldix.com> writes:

> On Sat, Jan 09, 2010 at 09:53:11AM -0800, Wil Reichert wrote:
>> Has anyone ever tried putting an SSD and a mechanical disc in RAID 1
>> using write-mostly?  The goal would be to extol the speed & latency
>> virtues of an SSD while retaining the integrity of the traditional
>> storage.  Would this setup even work as I expect it to?
>
>
> I think you are better served by trying out RAID10 in the far or offs=
et
> layouts. RAID1 would per se not gain from the low latency times of=20
> SSD. RAID1 should function the same with hard disk as with SSD,=20
> and with hard disk it would not make sense to multiplex reading
> of a file, as skipping and reading a block essentially takes the same
> time.
>
> Best regards
> Keld

With raid10 in the far or offset layout every (large) read and write
would always access both the SSD and rotating disk. That would make
every operation wait for the rotating disk to seek.


I think his initial idea of raid1 is verry good. With write-mostly all
reads should come from the fast SSD. I would also add write-behind.
That way writes will not wait for the rotating disk and get the full
SSD speed as well.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
