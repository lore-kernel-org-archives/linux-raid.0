From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 21:52:32 +1100 (EST)
Message-ID: <1e30801732ac82156aef4d99517a92a3.squirrel@neil.brown.name>
References: <20090212031009.23983.14496.stgit@notabene.brown>
    <20090212081148.GD9439@rap.rap.dk>
    <4993E82D.1020309@fairbairn-family.com>
    <20090212094604.GA11981@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212094604.GA11981@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Steve Fairbairn <steve@fairbairn-family.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, February 12, 2009 8:46 pm, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 12, 2009 at 09:13:17AM +0000, Steve Fairbairn wrote:
>> Keld J=F8rn Simonsen wrote:
>> >
>> >I would rather have functionality to convert raid10 to raid5.
>> >raid1 should be depreciated, as raid10,n2 for all purposes is the s=
ame
>> >but better implementation and performance, and raid10,f2 and raid10=
,o2
>> >are even better.  Nobody should use raid1 anymore.
>> >
>> Complete ignorance of raid10 here, but is raid10,<anything> bootable=
,
>> like raid1 is?  I use raid1 on my root and boot partitions.
>
> AFAIK, raid10,n2 in default mode (superblock etc) is bootable, as it
> looks like two copies of a normal FS. I think this was even reported
> on this list at some time.
>
> You are not the only one that does not know much about raid10. I thin=
k
> most Linux administrators don't.  And other system adminstrators most
> likely don't either.
>
> Maybe we should rename raid10 to raid1?
>
> Raid10 should just be an enhanced raid1. And I understand from Neil t=
hat
> raid10,o2 is mostly done because it is a standard raid1 layout. So it=
 is
> strange that it is not available with raid1 in Linux. And I also thin=
k
> that the raid10,f2 layout is available from some HW raid controllers,=
 as
> their implementation of raid1. So all what is in raid10 is other plac=
es
> considered raid1 stuff.
>

The 'offset' layout came about to be able to support a DDF format
which is called:

4.2.18 Integrated Offset Stripe Mirroring (PRL=3D11, RLQ=3D01)

(4.2.18 is the section of the document
 PRL is Primary Raid Level
 RLQ is Rail Level Qualifier
)
There is also

4.2.17 Integrated Adjacent Stripe Mirroring (PRL=3D 11, RLQ=3D00)

which is essentially the same as our n2 layout.

You should see their
4.3.4 Spanned Secondary RAID Level (SRL=3D03)

Though.  That would be really .. interesting to implement.


You can down load the ddf spec at

http://www.snia.org/tech_activities/standards/curr_standards/ddf/

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
