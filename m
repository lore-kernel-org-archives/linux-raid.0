From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: How to fix Current_Pending_Sector?
Date: Thu, 18 Mar 2010 17:47:13 -0400
Message-ID: <87f94c371003181447w2147cb87h41d8b16613ee1471@mail.gmail.com>
References: <4B992054.9020903@stud.tu-ilmenau.de>
	 <C7C3C86F.110A1%groups@email.iain.rauch.co.uk>
	 <72dbd3151003181237v6ebf87b7i4ec9563f6bfde758@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3151003181237v6ebf87b7i4ec9563f6bfde758@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Iain Rauch <groups@email.iain.rauch.co.uk>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 18, 2010 at 3:37 PM, David Rees <drees76@gmail.com> wrote:
> On Mon, Mar 15, 2010 at 4:20 AM, Iain Rauch
> <groups@email.iain.rauch.co.uk> wrote:
>> The 'Current_Pending_Sector' was still 1, so I dd zero onto the whol=
e drive.
>> I guess I could have just done part of it, but I suppose that verifi=
ed the
>> whole drive 'works'. It only took ~5 hours. Funnily enough this did =
fix the
>> Current_pending_sectors count back to zero. Still no error reports i=
n the
>> SMART data, and 'Reallocated_Event_Count' didn't go up - shouldn't t=
hat have
>> gone up to one?
>
> No - the drive was able to successfully write to the sector it was
> unable to read from. =A0If the write had failed, it would have
> reallocated the sector.
>
> -Dave

Dave,

Most sector writes are blind (ie. non-verified).

Is your theory that if the sector is marked as a Pending_Bad_Sector a
write is done, but it is verified, and a reallocate only occurs if the
verify fails?

I've never heard that theory, but it makes great sense.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
