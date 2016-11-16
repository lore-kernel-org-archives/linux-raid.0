From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 04/11] md/r5cache: caching mode of r5cache
Date: Wed, 16 Nov 2016 05:23:18 +0000
Message-ID: <222CE6B0-05AF-466A-98A1-290E3C29DA40@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-5-songliubraving@fb.com>
 <878tski63c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tski63c.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <A398A4E86C20994B933BC32292D2D076@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

>=20
>=20
>> +
>> +/*
>> + * this journal write must contain full parity,
>> + * it may also contain some data pages
>> + */
>> +static void r5c_handle_parity_cached(struct stripe_head *sh)
>=20
> I don't understand how this function name corresponds to what it does or
> when it is called.
> It is parts of activating the WRITE_OUT action for a stripe that has (or
> may have) been cached to the journal.  None of that is particularly
> about "parity".

It is called parity cached, because it is part of endio of the parity write=
=20
(to journal). We only write RAID disks (write out) after all parities are i=
n=20
journal. So if we name the function for its behavior, it will be something
like "start_write_out_to_raid"

>=20
> In generally the patch looks good, but it bothers me that we need to add
> tests on R5_InJournal in lots and lots of places.  It makes all those
> test sites more complex and so easily misunderstood.
> I wonder if there is some way we could add a new flag or something that
> would subsumes several of the tests.  So instead of adding a test for InJ=
ournal,
> we could replace the current test with a test for something new?
> Or maybe gather several tests that appear together into an inline.
> Or something.

This is a great point. Let me try that.=20

Thanks,
Song

