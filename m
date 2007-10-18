From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Thu, 18 Oct 2007 08:10:58 -0400
Message-ID: <170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	 <18198.62670.605246.270516@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18198.62670.605246.270516@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/18/07, Neil Brown <neilb@suse.de> wrote:
> On Wednesday October 17, snitzer@gmail.com wrote:
> > mdadm 2.4.1 through 2.5.6 works. mdadm-2.6's "Improve allocation and
> > use of space for bitmaps in version1 metadata"
> > (199171a297a87d7696b6b8c07ee520363f4603c1) would seem like the
> > offending change.  Using 1.2 metdata works.
> >
> > I get the following using the tip of the mdadm git repo or any other
> > version of mdadm 2.6.x:
> >
> > # mdadm --create /dev/md2 --run -l 1 --metadata=1.0 --bitmap=internal
> > -n 2 /dev/sdf --write-mostly /dev/nbd2
> > mdadm: /dev/sdf appears to be part of a raid array:
> >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > mdadm: /dev/nbd2 appears to be part of a raid array:
> >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > mdadm: RUN_ARRAY failed: Input/output error
> > mdadm: stopped /dev/md2
> >
> > kernel log shows:
> > md2: bitmap initialized from disk: read 22/22 pages, set 715290 bits, status: 0
> > created bitmap (350 pages) for device md2
> > md2: failed to create bitmap (-5)
>
> Could you please tell me the exact size of your device?  Then should
> be able to reproduce it and test a fix.
>
> (It works for a 734003201K device).

732456960K, it is fairly surprising that such a relatively small
difference in size would prevent it from working...

regards,
Mike
