From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 20:21:12 +1100 (EST)
Message-ID: <12039e3b9172d1a1347b8396cab59f11.squirrel@neil.brown.name>
References: <20090212031009.23983.14496.stgit@notabene.brown>
    <20090212081148.GD9439@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212081148.GD9439@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, February 12, 2009 7:11 pm, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 12, 2009 at 02:10:10PM +1100, NeilBrown wrote:
>> Comments and testing very welcome.
>
> I would rather have functionality to convert raid10 to raid5.
> raid1 should be depreciated, as raid10,n2 for all purposes is the sam=
e
> but better implementation and performance, and raid10,f2 and raid10,o=
2
> are even better.  Nobody should use raid1 anymore.

That is a fairly simplistic view.
raid1 supports --write-mostly and --write-behind which raid10 is unlike=
ly
ever to support.
Certainly in many cases raid10 is just as good or better than raid1
though.

Certainly a raid10->raid5 conversion for a 2-drive n2 configuration
is trivial to arrange.  Other conversions are less likely to be support=
ed
as they require significant non-trivial rearrangement of data.

Thanks for the comment.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
