From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: no resync after hotadd
Date: Thu, 25 Sep 2003 09:18:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030925071820.GD25758@marowsky-bree.de>
References: <E5DA6395B8F9614EB7A784D628184B200D9AAA@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E5DA6395B8F9614EB7A784D628184B200D9AAA@hdsmsx402.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-09-23T10:43:55,
   "Cress, Andrew R" <andrew.r.cress@intel.com> said:

> I've seen this before, but it is very reproducable on the SuSE/UL sys=
tem
> I am testing on now.

Please try the latest kernel from
ftp.suse.com:/pub/people/mantel/next/RPM/ (if I got the path right).

There have been some md bugs fixed in the last few days, one of them
relating to resync not starting (which we attributed to the locking bug=
s
in md). I'd guess it has been fixes.

Otherwise, to lighten the load on the public channels, please post
UL/SuSE specific bugs via the SuSE/UL Bugzilla and only post to the Ope=
n
Source lists if you can reproduce with vanilla Linux. (If you can't,
please mention that in the bugzilla ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
