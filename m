From: Shai <shaibn@gmail.com>
Subject: Re: which disk the the one that data is on?
Date: Fri, 21 Jul 2006 10:07:31 +0300
Message-ID: <e3edb0fa0607210007o7e1c1248o7565d032e1254121@mail.gmail.com>
References: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
	 <17596.41907.608404.634683@cse.unsw.edu.au>
	 <e3edb0fa0607180223q11193d9ey6a6569bded1feb4@mail.gmail.com>
	 <17596.44863.331069.588455@cse.unsw.edu.au>
	 <e3edb0fa0607182233l2dd64395o884e523b7820676d@mail.gmail.com>
	 <17598.52511.607140.257550@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17598.52511.607140.257550@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks thus far :)

Shai

On 7/20/06, Neil Brown <neilb@suse.de> wrote:
> On Wednesday July 19, shaibn@gmail.com wrote:
> > Hi,
> >
> > Another question on this matter please:
> > If there is a raid5 with 4 disks and 1 missing, and we add that disk,
> > while its doing the resync of that disk, how do we know which disk it
> > is (if we forgot what one we added)?
>
> mdadm --detail will list all the devices.  The one that is being
> recovered won't be 'sync' - the others will.
>
> NeilBrown
>
