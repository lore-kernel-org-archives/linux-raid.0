From: Andrew Burgess <aab@cichlid.com>
Subject: Re: grow raid 6: different errors with mdadm 3.0.3 and 3.1
Date: Thu, 26 Nov 2009 07:02:03 -0800
Message-ID: <1259247723.23899.0@athlon>
References: <1259086899.4139.4@athlon>
	<20091126142227.496da980@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091126142227.496da980@notabene.brown> (from neilb@suse.de on
	Wed Nov 25 19:22:27 2009)
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/25/2009 07:22:27 PM, Neil Brown wrote:
> On Tue, 24 Nov 2009 10:21:39 -0800 Andrew Burgess <aab@cichlid.com>  
> wrote:

> > mdadm 3.1:
> >
> > sudo ./mdadm -G /dev/md1 --raid-devices=15
> > mdadm: this change will reduce the size of the array.
> >         use --grow --array-size first to truncate array.
> >         e.g. mdadm --grow /dev/md1 --array-size 928142080


> Thanks for the report.

Thanks for the fix. I grabbed the git head version and the
resize is grinding away now.


