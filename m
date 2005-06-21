From: Ron Murray <murrayr@dor.state.ma.us>
Subject: Re: Is my raid-1 array working?
Date: Tue, 21 Jun 2005 12:37:38 -0400
Message-ID: <42B84252.1070408@dor.state.ma.us>
References: <42B8146D.4030004@dor.state.ma.us>
    <13541.194.178.120.170.1119365942.squirrel@194.178.120.170>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13541.194.178.120.170.1119365942.squirrel@194.178.120.170>
Sender: linux-raid-owner@vger.kernel.org
To: jurriaan@rivierenland.xs4all.nl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jurriaan Kalkman wrote:
>> > md: Autodetecting RAID arrays.
>> > md: autorun ...
>> > md: ... autorun DONE.
> 
> 
> Since no partitions seem to be recognized here, my first question would
> be: are the partitions of type 0xfd - the one you need for them to be
> automatically recognized?
> 
> Kind regards,
> Jurriaan


Aaaaahhhhhhhhhhhhhhh!!!! That fixed it. I must have missed that part.

Thanks for the help.

  .....Ron

**********************************************************************
This email and any files transmitted with it are confidential and 
intended solely for the use of the individual or entity to whom they   
are addressed. If you have received this email in error please notify 
the system manager at postmaster at dor.state.ma.us.
**********************************************************************
