From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Mon, 01 Feb 2010 15:06:32 -0500
Message-ID: <4B673448.4080002@tmr.com>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>	<20100109192326.GB16383@rap.rap.dk> <87bpgmyu37.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bpgmyu37.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Keld Jorn Simonsen <keld@keldix.com>, Wil Reichert <wil.reichert@gmail.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Keld J=F8rn Simonsen <keld@keldix.com> writes:
>
>  =20
>> On Sat, Jan 09, 2010 at 09:53:11AM -0800, Wil Reichert wrote:
>>    =20
>>> Has anyone ever tried putting an SSD and a mechanical disc in RAID =
1
>>> using write-mostly?  The goal would be to extol the speed & latency
>>> virtues of an SSD while retaining the integrity of the traditional
>>> storage.  Would this setup even work as I expect it to?
>>>      =20
>> I think you are better served by trying out RAID10 in the far or off=
set
>> layouts. RAID1 would per se not gain from the low latency times of=20
>> SSD. RAID1 should function the same with hard disk as with SSD,=20
>> and with hard disk it would not make sense to multiplex reading
>> of a file, as skipping and reading a block essentially takes the sam=
e
>> time.
>>
>> Best regards
>> Keld
>>    =20
>
> With raid10 in the far or offset layout every (large) read and write
> would always access both the SSD and rotating disk. That would make
> every operation wait for the rotating disk to seek.
>
>
> I think his initial idea of raid1 is verry good. With write-mostly al=
l
> reads should come from the fast SSD. I would also add write-behind.
> That way writes will not wait for the rotating disk and get the full
> SSD speed as well.
>  =20

I had an SSD waiting to be deployed, and I tried putting a journal on i=
t=20
and using a mount with data=3Djournal. Supposedly when the data is writ=
ten=20
to the journal the write will be "complete" and effective write speed=20
for many small random writes will be higher. I don't have the results=20
handy, but they were not so great that I went out and got another SDD.

--=20
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
