From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 2/6] Show device as journal in --detail --examine
Date: Wed, 2 Sep 2015 07:04:26 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AA0104B4C7DD@PRN-MBX02-4.TheFacebook.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
 <1440804426-1461372-3-git-send-email-songliubraving@fb.com>
 <20150902065303.GA20708@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150902065303.GA20708@infradead.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, September 1, 2015 11:53 PM
> To: Song Liu
> Cc: linux-raid@vger.kernel.org; Shaohua Li; dan.j.williams@intel.com;
> neilb@suse.de; hch@infradead.org
> Subject: Re: [PATCH 2/6] Show device as journal in --detail --examine
> 
> >  #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must
> be honoured */
> > +#define	MD_FEATURE_JOURNAL		512 /* support write
> journal */
> 
> The kernel patches are using 256 here, so your userspace won't work with them
> but rather generate very unhelpful warnings:
> 
> [   16.177710] md: sdc does not have a valid v1.2 superblock, not importing!
> [   16.178634] md: md_import_device returned -22
> mdadm: ADD_NEW_DISK for /dev/sdc failed: Invalid argument

The latest kernel patches (now on Neil's devel branch) is using the following. We made this change because 256 is used by MD_FEATURE_CLUSTERED. 

#define MD_FEATURE_CLUSTERED    256 /* clustered MD */
#define MD_FEATURE_JOURNAL    512 /* support write cache */
