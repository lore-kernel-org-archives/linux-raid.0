From: Iustin Pop <iusty@k1024.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 09:53:49 +0200
Message-ID: <20071020075349.GA17431@teal.hq.k1024.org>
References: <18200.49267.763509.924873@stoffel.org> <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan> <18200.53593.687483.120827@stoffel.org> <1192810534.1666.68.camel@firewall.xsintricity.com> <18200.56684.14194.630264@stoffel.org> <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1192830129.1666.103.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 19, 2007 at 05:42:09PM -0400, Doug Ledford wrote:
> The simple fact of the matter is there are only two type of raid devices
> for the purpose of this issue: those that fragment data (raid0/4/5/6/10)
> and those that don't (raid1, linear).
> 
> For the purposes of this issue, there are only two states we care about:
> the raid array works or doesn't work.
Yes, but "doesn't work" doesn't mean only that the array fails to start.

> If the raid array works, then you *only* want the system to access the
> data via the raid array.  If the raid array doesn't work, then for the
> fragmented case you *never* want the system to see any of the data from
> the raid array (such as an ext3 superblock) or a subsequent fsck could
> see a valid superblock and actually start a filesystem scan on the raw
> device, and end up hosing the filesystem beyond all repair after it hits
> the first chunk size break (although in practice this is usually a
> situation where fsck declares the filesystem so corrupt that it refuses
> to touch it, that's leaving an awful lot to chance, you really don't
> want fsck to *ever* see that superblock).
Honestly, I don't see how a properly configured system would start
looking at the physical device by mistake. I suppose it's possible, but
I didn't have this issue.

> If the raid array is raid1, then the raid array should *never* fail to
> start unless all disks are missing (in which case there is no raw device
> to access anyway).  The very few failure types that will cause the raid
> array to not start automatically *and* still have an intact copy of the
> data usually happen when the raid array is perfectly healthy, in which
> case automatically finding a constituent device when the raid array
> failed to start is exactly the *wrong* thing to do (for instance, you
> enable SELinux on a machine and it hasn't been relabeled and the raid
> array fails to start because /dev/md<blah> can't be created because of
> an SELinux denial...all the raid1 members are still there, but if you
> touch a single one of them, then you run the risk of creating silent
> data corruption).

It's not only about the activation of the array. I'm mostly talking
about RAID1, but the fact that migrating between RAID1 and plain disk is
just a few hundred K at the end increases the flexibility very much.
With superblock at the start, you can't decide to convert a plain disk
to RAID1 without shifting all data, with the superblock at the end it's
perfectly possible.

Also, sometime you want to recover as much as possible from a not intact
copy of the data...

Of course, different people have different priorities, but as I said, I
like that this conversion is possible, and I never had the case of a
tool saying "hmm, /dev/md<something> is not there, let's look at
/dev/sdc instead".

thanks,
iustin
