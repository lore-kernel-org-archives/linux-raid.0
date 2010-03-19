From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: How to fix Current_Pending_Sector?
Date: Fri, 19 Mar 2010 08:22:26 +0100
Message-ID: <4BA32632.3050500@stud.tu-ilmenau.de>
References: <4B992054.9020903@stud.tu-ilmenau.de>	 <C7C3C86F.110A1%groups@email.iain.rauch.co.uk>	 <72dbd3151003181237v6ebf87b7i4ec9563f6bfde758@mail.gmail.com> <87f94c371003181447w2147cb87h41d8b16613ee1471@mail.gmail.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371003181447w2147cb87h41d8b16613ee1471@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Greg,

Am 18.03.2010 22:47, schrieb Greg Freemyer:
> On Thu, Mar 18, 2010 at 3:37 PM, David Rees <drees76@gmail.com> wrote:
>> On Mon, Mar 15, 2010 at 4:20 AM, Iain Rauch
>> <groups@email.iain.rauch.co.uk> wrote:
>>> The 'Current_Pending_Sector' was still 1, so I dd zero onto the whole drive.
>>> I guess I could have just done part of it, but I suppose that verified the
>>> whole drive 'works'. It only took ~5 hours. Funnily enough this did fix the
>>> Current_pending_sectors count back to zero. Still no error reports in the
>>> SMART data, and 'Reallocated_Event_Count' didn't go up - shouldn't that have
>>> gone up to one?
>>
>> No - the drive was able to successfully write to the sector it was
>> unable to read from.  If the write had failed, it would have
>> reallocated the sector.
>>
>> -Dave
> 
> Dave,
> 
> Most sector writes are blind (ie. non-verified).

That is certainly right!

> 
> Is your theory that if the sector is marked as a Pending_Bad_Sector a
> write is done, but it is verified, and a reallocate only occurs if the
> verify fails?

If the drives has noted errorneous behaviour on a sector (i.e. marked it
pending), it will try to resolve the problem by verify.  It just only
makes sense that way, doesn't it?
> 
> I've never heard that theory, but it makes great sense.

IC, it does ;)
> 
> Greg

Stefan
