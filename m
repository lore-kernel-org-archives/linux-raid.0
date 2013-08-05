From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Bugreport ddf rebuild problems
Date: Mon, 05 Aug 2013 23:24:28 +0200
Message-ID: <5200180C.6060604@arcor.de>
References: <51FAB74B.4030200@gmail.com>	<51FAB282.6040303@arcor.de> <CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com> <51FACF7C.50400@arcor.de> <51FADCA5.1080801@arcor.de> <51FAE319.6030604@arcor.de> <51FCD0BB.1040402@gmail.com> <51FE234A.4060808@gmail.com> <51FFD913.1090301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51FFD913.1090301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Albert, Neil,

I just submitted a new patch series; patch 3/5 integrates your 2nd case
as a new unit test and 4/5 should fix it.

However @Neil: I am not yet entirely happy with this solution. AFAICS
there is a possible race condition here, if a disk fails and mdadm -CR
is called to create a new array before the metadata reflecting the
failure is written to disk. If a disk failure happens in one array,
mdmon will call reconcile_failed() to propagate the failure to other
already known arrays in the same container, by writing "faulty" to the
sysfs state attribute. It can't do that for a new container though.

I thought that process_update() may need to check the kernel state of
array members against meta data state when a new VD configuration record
is received, but that's impossible because we can't call open() on the
respective sysfs files. It could be done in prepare_update(), but that
would require major changes, I wanted to ask you first.

Another option would be changing manage_new(). But we don't seem to have
a suitable metadata handler method to pass the meta data state to the
manager....

Ideas?

Regards
Martin

