From: Nicolas Noble <nicolas@nobis-crew.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 02:18:17 -0700
Message-ID: <CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
 <22368.45414.256389.605050@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22368.45414.256389.605050@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> it
> *might* make sense to look at ceph or some other distributed
> filesystem.

I was trying to avoid that, mainly because that doesn't seem to be as
supported as a more straightforward raids+lvm2 scenario. But I might
be willing to reconsider my position in light of such data losses.

> no filesystem I know handles that without either going
> readonly, or totally locking up.

Which, to be fair, is exactly what I'm looking for. I'd rather see the
filesystem lock itself up, until a human tries to restore the failed
raid back online. But my recent experience and experiments show me
that the filesystems actually don't lock themselves up, and don't go
read only for quite some time, and heavy heavy data corruption will
then happen. I'd be much more happy if the behavior was that the
filesystem locks itself up instead of self destroying over time.
