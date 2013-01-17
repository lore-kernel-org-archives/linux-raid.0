From: Charles Polisher <cpolish@surewest.net>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Thu, 17 Jan 2013 07:12:17 -0800
Message-ID: <20130117151217.GB29871@kevin>
References: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
 <84A937D219C2B44EB8EA44831ACA1E4916D902C5@PRN-MBX02-3.TheFacebook.com>
 <CAKnNFz8dZVgS7M_rmQx0c_S+jo46EGs2GWAHc99ziaAR5OQp+w@mail.gmail.com>
 <D9FFE20C522965449E182ACE73889AEB1904DF39@IRSMSX102.ger.corp.intel.com>
 <CAKnNFz-Gy7vJjErKijV3=HV16Br_uq4rxfbbB9sFHHVi3SWtOw@mail.gmail.com>
 <D9FFE20C522965449E182ACE73889AEB1904E2AC@IRSMSX102.ger.corp.intel.com>
 <CAKnNFz_5dsukFe1TP9E1X4P-XYAR0timuDq=Wjb1Q4sdXPa=tg@mail.gmail.com>
 <CAA9_cmfYRoRrF_Q=VkNctyte3UMfbDiyJ7DgaryMnaFD-NV4ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmfYRoRrF_Q=VkNctyte3UMfbDiyJ7DgaryMnaFD-NV4ew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: chris <tknchris@gmail.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, Neil Brown <neilb@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan Williams wrote:
> chris <tknchris@gmail.com> wrote:
> > any idea why it wont assemble? I thought even if data was corrupt I
> > should be able to force it to assemble and look at it to determine if
> > it is corrupt or in tact
> 
> A bug in mdadm was introduced shortly after the "missing" support was
> added.  Looks like you need 3.2.6.

Probably unrelated, but in case you were unaware, ICHxR chipsets
have snared me in the past with bugs that were later corrected
by firmware updates from Intel. If I remember correctly from
upthread, you were at one point attempting to / running this
array with such hardware. If this is still an option, you might
check your firmware version and the release notes for any more
recent release. This won't fix software RAID but it could
conceivably coax the ICH10R into assembling the array.

-- 
Charles

