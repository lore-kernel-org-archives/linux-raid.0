From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Changing Chunk Size on Array
Date: Sat, 17 Jul 2010 16:45:54 -0500
Message-ID: <CB.A8.04655.C94224C4@cdptpa-omtalb.mail.rr.com>
References: <20100718033047.2ee80eac@natsu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100718033047.2ee80eac@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Roman Mamedov' <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: Roman Mamedov [mailto:roman@rm.pp.ru]
> Sent: Saturday, July 17, 2010 4:31 PM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Changing Chunk Size on Array
> 
> On Sat, 17 Jul 2010 16:15:55 -0500
> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> 
> >
> > 	I'm thinking about changing the chunk size on one of my arrays in
> > order to potentially improve performance.  The man page rather suggests
> -c
> > is a vlaid option under Grow mode, although it doesn't specifically say
> > mdadm supports it under --grow.  Is it indeed supported under mdadm
> 2.6.7.2
> > and kernel 2.6.26-2?  Assuming so, I would like to know a bit more about
> the
> > change before issuing the command.  Speficialy, what are the details of
> the
> > process?  Does the entire (RAID 6) array have to be re-written, such as
> is
> > the case with adding a drive to the array?  Does the recovery start
> > immediately?  Can it be interrupted and then continue at a later time?
> 
> Out of curiosity, which chunk size do you have, and which you want to
> change
> it to, and do you expect the new size to be faster based on any tests?

	The current chunk is 256K.  One of my other arrays on a nearly
identical platform seems to have better performance at 1024K.  I haven't
made any decisions, yet on what the new value would be, or even in fact if I
will actually consider doing it.  I'm still at the evaluation stage.  Most
of the files on the array are in the 10G - 30G range in size, and they are
generally read and written sequentially.  The individual members are
thirteen 1T drives in an 11T RAID6 array.

