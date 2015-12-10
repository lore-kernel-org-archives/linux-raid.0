From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 0/3] mdadm: re-add journal to array with bad journal
Date: Thu, 10 Dec 2015 22:37:34 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AA0104BCF1B9@PRN-MBX02-4.TheFacebook.com>
References: <1449018805-320020-1-git-send-email-songliubraving@fb.com>
 <87si3ac62s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87si3ac62s.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, Shaohua Li <shli@fb.com>, "hch@infradead.org" <hch@infradead.org>, Kernel Team <Kernel-team@fb.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.com]
> Sent: Thursday, December 10, 2015 2:06 PM
> To: Song Liu <songliubraving@fb.com>; linux-raid@vger.kernel.org
> Cc: dan.j.williams@intel.com; Shaohua Li <shli@fb.com>; hch@infradead.org;
> Kernel Team <Kernel-team@fb.com>; Song Liu <songliubraving@fb.com>
> Subject: Re: [PATCH 0/3] mdadm: re-add journal to array with bad journal
> 
> On Wed, Dec 02 2015, Song Liu <songliubraving@fb.com> wrote:
> 
> > These patches try to recreate missing/faulty journal in mdadm. Since
> > the array is readonly with journal missing, it is necessary to restart
> > the array after recreating journal.
> >
> > Song Liu (3):
> >   add sysfs_array_state to struct mdinfo
> >   [mdadm] recreate journal in mdadm
> >   make .spec file work
> 
> I didn't get that third patch???

That's my local hack to .spec file. Didn't mean to send it. 

> 
> The patches generally look good, but it bothers me that you have to stop and
> restart the array for the added journal to work.  Can we just teach the kernel to
> accept a new journal on an active array, and then use that functionality in
> mdadm?
> That is certainly what I want in the longer term and I'm not sure it makes sense
> to have a half-way "--add-journal" that doesn't do the whole job.

We will look into hot_add option.  

Thanks,
Song
