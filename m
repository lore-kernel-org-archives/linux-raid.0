From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sun, 2 Mar 2008 09:00:23 +0000 (UTC)
Message-ID: <loom.20080302T084959-207@post.gmane.org>
References: <1204195554.16924.16.camel@franck-gusty> <loom.20080228T223023-79@post.gmane.org> <20080301204020.GC10278@rap.rap.dk> <loom.20080301T213935-669@post.gmane.org> <20080302003057.GA6958@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen <keld <at> dkuug.dk> writes:

> I have understood chunk to be a set of sectors on a single device.

You are right, I completely botched my reply

>> Creating more than one array may be OK when you very
>> precisely know your load profile per table

>> your best bet is "to maintain, for each
>> request, as much disk heads available as possible", carpet-bomb the =
array
>> with all requests and let the elevator(s) optimize

> This is for bigger operations. I believe that for smaller operations,
> such as a random read in a database, you would only like to have one =
IO
> operation on one device.

We agree on this. My reply was tailored upon the prerequisite of a chun=
k size
defined to be slightly superior to the size of the data needed for most=
 requests.

Using multiple arrays may be useful if all tables are accessed at simil=
ar rates
while some have much bigger average amount of bytes implied by any requ=
est:
their array need a bigger chunk size.

> > > Some other factors may be more important: such as the ability to =
survive
> > > disk crashes
> >=20
> > That's very true, however one may not neglect logistics.

> Yes, rebuild time would also be a factor.

I think so

> Smaller raids are quicker to rebuild

It depends on device performance (putting online a recent small-capacit=
y device
will lead to quick rebuild), workload during rebuild...

> for raid10,f2 -
> probebly limited by the write speed of the replacing device.

I think so.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
