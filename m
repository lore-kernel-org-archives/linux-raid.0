From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v5 6/8] md/r5cache: sysfs entry r5c_state
Date: Fri, 21 Oct 2016 21:20:43 +0000
Message-ID: <9EB7E283-3368-47A6-BAA4-ADC1FD456617@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
 <20161013054944.1038806-7-songliubraving@fb.com>
 <87lgxlxeq5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgxlxeq5.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <806BDCA8C83AE444A45FF9CB03AE8101@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 18, 2016, at 7:19 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Thu, Oct 13 2016, Song Liu wrote:
>=20
>> r5c_state have 4 states:
>> * no-cache;
>> * write-through (write journal only);
>> * write-back (w/ write cache);
>> * cache-broken (journal missing or Faulty)
>=20
> I don't like this.
>=20
> We already have a mechanism for removing a failed device from
> an array: write 'remove' to the 'state' file in the relevant dev-*
> subdirectory.
> You can also use that file to tell if the journal has failed.

I think we would like an separate mechanism to remove "journal feature",
not "journal device".  Maybe we should put it in an different sysfs file.=20


> Please call the file something a little more obvious that 'r5c_state',
> maybe 'journal_mode', and use it only to switch between write-through
> and write-back.
> If there is no journal, then either remove the file, or have writes fail
> and reads return something obvious ... maybe ENODEV.

Thanks,
Song

