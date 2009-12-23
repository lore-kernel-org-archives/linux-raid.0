From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: raid0 not growable?
Date: Wed, 23 Dec 2009 23:28:37 +0000
Message-ID: <73e903670912231528u6d3cd2ekd0fa4ade06adbcf5@mail.gmail.com>
References: <73e903670912230552n226e9052q182174cba32f3c54@mail.gmail.com>
	<20091224094557.1ae96a0d@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091224094557.1ae96a0d@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 23, 2009 at 10:45 PM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 23 Dec 2009 13:52:54 +0000
> Kristleifur Da=F0ason <kristleifur@gmail.com> wrote:
>
>> Hi,
>>
>> I'm running a raid0 array over a couple of raid6 arrays. I had plann=
ed
>> on growing the arrays in time, and now turns out to be the time.
>>
>> To my chagrin, searches indicate that raid0 isn't growable. Can anyo=
ne
>> confirm this before I wipe and reconfigure?
>
> That is correct, you cannot currently grow md/raid0.
>
> If the two raid6 arrays are exactly the same size, then you
> could grow the two raid6 arrays, create a new raid0 over them
> with the same block size and all your data will still be there.
> But if they are not the same size, that won't work.
>
> NeilBrown
>

Many thanks for the reply. (Re-cc'd to the linux-raid list. Hope that's=
 OK.)

1.
The raid6 arrays are exactly alike. Do I just do a create a new raid0
with the right size, device count and chunk-size parameters? I trust
your advice, but I am also certain of my own foolishness. I can't
fully picture what happens to the data on the array -- Specifically,
I'm thinking about whether to use --assume-clean or not. The
documentation says not. I am guessing that a newly-created raid0
doesn't do any syncing/resyncing anyway - it just sets up the array
structure and metadata and I am left to my own devices to fill it with
data.

Current chunksize is 256 and metadata is 1.1. So it's just a "mdadm
--create /dev/md_bigraid0 --level=3D0 --raid-devices=3D2 --metadata=3D1=
=2E1
--chunksize=3D256 /dev/md_raid6a /dev/md_raid6b", right?

2.
I have a JFS filesystem on the big raid0. Once I have the bigger raid0
built, I assume that I would first do a read-only fsck.jfs, which will
succeed if I did everything correctly. Then I do a remount with the
"resize" option to JFS to finally grow the JFS filesystem.

--

Sincere thanks. I hope I shall be able to contribute something
meaningful to mdadm when the company is richer and my time is freer :)
In the meantime, is there any preferred way of donating to mdadm or
sponsoring it?

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
