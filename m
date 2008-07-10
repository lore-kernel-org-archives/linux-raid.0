From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: resync'ing - what is going on
Date: Thu, 10 Jul 2008 12:45:40 -0500
Message-ID: <cccedfc60807101045x207d27d7r9e61e697632d0e59@mail.gmail.com>
References: <20080710165459.GA17542@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080710165459.GA17542@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 10, 2008 at 11:54 AM, Keld J=F8rn Simonsen <keld@dkuug.dk> =
wrote:
> I would like to know what is going on wrt resyncing, how it is done.
> This is because I have some ideas to speed up the process.
> I have noted for a 4 drive raid10,f2 array that only about 25 % of th=
e
> IO speed is used during the rebuid, I would like to have something li=
ke
> 90 % as a goal.
>
> This is especially for raid10,f2, where I think I can make it much
> better, but posssibly also for other raid types, as input to an
> explanation on the wiki of what is really going on.

Well, my guess (and from a quick scan of the source) is that basically
raid10 resync by starting at the first logical block or stripe and
proceeds through the last.  This means that there is quite a bit of
seeking going on. IMO, the loop should look more like this:

for component in all_components:
  for stripe_or_block on this component:
    read_or_check_or_whatever(stripe_or_block)

This way, assuming no interference from other sources, each component
does the minimal seeking.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
