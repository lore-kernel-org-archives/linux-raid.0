From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 14:00:01 -0600
Message-ID: <cccedfc60901191200q30ed8bcdqde2a547fc7f33df9@mail.gmail.com>
References: <18763.7881.300921.177207@notabene.brown>
	 <20081230191250.70701c5c@absurd>
	 <18803.53032.383350.741460@nbeee.brown>
	 <20090119122505.GB23623@rap.rap.dk>
	 <8CB487FD08E50F2-152C-7B6@webmail-dx12.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CB487FD08E50F2-152C-7B6@webmail-dx12.sysops.aol.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: keld@dkuug.dk, neilb@suse.de, janek_listy@wp.pl, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I guess what I'd like to see more than anything else is not raid5 or
raid6 but raidN where N can be specified at the start and grown. While
I'm not a fan of ZFS's rulebreaking one thing it does (or claims to
do) strikes me as "the future" - the ability to specify X protection
bits and to increase or decrease X as needs see fit. It also strikes
me that there are several ways to do this but fundamentally it boils
down to "we don't trust our drives anymore and there we wish to
protect our data against their failure". Given 5 or 10 or 50 drives
how does one really protect their data effectively and allow their
data pool to grow without large quantities of hoop-jumping?

I'd really like to see a re-thinking of data protection (parity or
data duplication) at the block layer - it need not be RAID as we know
it but IMO something has to be done - rapidly do we near the
precipice!

On Mon, Jan 19, 2009 at 1:03 PM,  <thomas62186218@aol.com> wrote:
> I agree with Keld on the need for RAID 10 expansion and increasing RA=
ID 10
> performance. Those are the hottest issues I see right now.
>
> -Thomas
>
>
> -----Original Message-----
> From: Keld J=F8rn Simonsen <keld@dkuug.dk>
> To: Neil Brown <neilb@suse.de>
> Cc: Janek Kozicki <janek_listy@wp.pl>; linux-raid@vger.kernel.org
> Sent: Mon, 19 Jan 2009 4:25 am
> Subject: Re: Roadmap for md/raid ???
>
>
>
>
>
>
>
>
>
>
> I would like to see some enhancements to  the raid code:
>
> 1. removal of need to set the readahead to say 32 MiB for certain
>  raid types to get the desired performance
>
> 2. getting resync and other performance up for raid10, possibly
>  using bigger buffers.
>
> 3. growing raid10.
>
> I wonder where this is placed in the roadmap. Neil?
>
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
