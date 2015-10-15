From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH] MD: fix missing cpu_to_le32 for MD_FEATURE_JOURNAL
Date: Thu, 15 Oct 2015 06:54:00 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AA0104B93871@PRN-MBX02-4.TheFacebook.com>
References: <1444888404-994890-1-git-send-email-songliubraving@fb.com>
 <87d1wgwsbx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1wgwsbx.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids


> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.com]
> Sent: Wednesday, October 14, 2015 11:37 PM
> To: Song Liu <songliubraving@fb.com>; linux-raid@vger.kernel.org
> Cc: Song Liu <songliubraving@fb.com>; Shaohua Li <shli@fb.com>
> Subject: Re: [PATCH] MD: fix missing cpu_to_le32 for
> MD_FEATURE_JOURNAL
> 
> Song Liu <songliubraving@fb.com> writes:
> 
> > sb->feature_map is __le32, add missing cpu_to_le32()
> >
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
> >  drivers/md/md.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index 378b9f0..163b548
> > 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1812,7 +1812,7 @@ retry:
> >  		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
> >
> >  	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
> > -		sb->feature_map |= MD_FEATURE_JOURNAL;
> > +		sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
> >
> >  	rdev_for_each(rdev2, mddev) {
> >  		i = rdev2->desc_nr;
> > --
> > 2.4.6
> 
> Thanks.
> I just emrged this in rather than create a new patch.
> 
> NeilBrown

That's awesome!

Thanks,
Song

