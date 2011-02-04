From: Jon Forrest <jlforrest@berkeley.edu>
Subject: Re: mdadm: ADD_NEW_DISK failed: Invalid argument
Date: Fri, 04 Feb 2011 09:02:25 -0800
Message-ID: <4D4C3121.2010508@berkeley.edu>
References: <iifhb6$inv$1@dough.gmane.org> <20110204131028.5cae3c88@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204131028.5cae3c88@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/3/2011 6:10 PM, NeilBrown wrote:

> Probably chunk size is larger than your 100k devices.
>
> Try:
>
>    mdadm --create /dev/md1 --raid-devices=2 --level=0 --metadata=1.0
>    --chunksize=4 ....
>
> The metadata=1.0 causes the least amount of space to be used for metadata.

That worked (should be --bitmap-chunk instead of --chunksize).

> OR just make much larger files.  Surely you can spare a few meg??

Absolutely. My point is just that a failure such as this
should result in a meaningful error message.
Ironically, mdadm seems to have regressed.
On Ubuntu 10.10, which uses version 2.6.7.1 of
mdadm I see the kind of error message I'd expect, e.g.

	mdadm: /dev/loop0 is too small: 100K
	mdadm: /dev/loop1 is too small: 100K

However, on RHEL6, which uses the newer version 3.1.3 of
mdadm, I get

	mdadm: ADD_NEW_DISK for /dev/loop2 failed: Invalid argument

This looks like a regression to me.

I'd agree that what I'm doing is unrealistic. I was
just preparing a document about how to use mdadm so
I didn't need large volumes. But, it would be nice
if the latest version of mdadm did what earlier
versions did.

Cordially,
-- 
Jon Forrest
Research Computing Support
College of Chemistry
173 Tan Hall
University of California Berkeley
Berkeley, CA
94720-1460
510-643-1032
jlforrest@berkeley.edu
