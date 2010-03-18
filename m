From: David Rees <drees76@gmail.com>
Subject: Re: How to fix Current_Pending_Sector?
Date: Thu, 18 Mar 2010 12:37:36 -0700
Message-ID: <72dbd3151003181237v6ebf87b7i4ec9563f6bfde758@mail.gmail.com>
References: <4B992054.9020903@stud.tu-ilmenau.de> <C7C3C86F.110A1%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C7C3C86F.110A1%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 4:20 AM, Iain Rauch
<groups@email.iain.rauch.co.uk> wrote:
> The 'Current_Pending_Sector' was still 1, so I dd zero onto the whole drive.
> I guess I could have just done part of it, but I suppose that verified the
> whole drive 'works'. It only took ~5 hours. Funnily enough this did fix the
> Current_pending_sectors count back to zero. Still no error reports in the
> SMART data, and 'Reallocated_Event_Count' didn't go up - shouldn't that have
> gone up to one?

No - the drive was able to successfully write to the sector it was
unable to read from.  If the write had failed, it would have
reallocated the sector.

-Dave
