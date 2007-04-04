From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: s2disk and raid
Date: Thu, 05 Apr 2007 00:47:49 +0400
Message-ID: <46140EF5.8080603@tls.msk.ru>
References: <20070403175521.70e6c876@commensaal.drs.p> <17939.13752.164747.486393@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17939.13752.164747.486393@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tim Dijkstra <newsuser@famdijkstra.org>, suspend-devel List <suspend-devel@lists.sourceforge.net>, linux-raid@vger.kernel.org, 415441@bugs.debian.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday April 3, newsuser@famdijkstra.org wrote:
[]
>> After the power cycle the kernel boots, devices are discovered, among
>> which the ones holding raid. Then we try to find the device that holds
>> swap in case of resume and / in case of a normal boot.
>>
>> Now comes a crucial point. The script that finds the raid array, finds
>> the array in an unclean state and starts syncing.
[]
> So you can start arrays 'readonly', and resume off a raid1 without any
> risk of the the resync starting when it shouldn't.

But I wonder why this raid is necessary in the first place.
For raid1, assuming the superblock is at the end, -- the only
thing needed for resume is one component of the mirror.  I.e,
if your raid array is (was) composed off hda1 and hdb1, either
of the two will do as source of resume image.  The trick is to
find which, in case the array was degraded -- and mdadm does the
job here, but assembling it isn't really necessary.  Maybe mdadm
can be told to "examine" the component devices and write a short
line to stdout *instead* of real assembly (like mdadm -A --dummy),
to show the most recent component, and the offset if superblock
is at the beginning... having that, it will be possible to resume
from that component directly...

By the way, my home-grown initramfs stuff accepts several devices
for resume= command line, and tries each in turn.  If main disks
has more-or-less stable names, this may be an alternative way.
To mean, just give the component devices in resume= line...

Yes, this way it may do some weird things in case when the original
swap array was degraded (with first component, which contained a
valid resume image, removed from the array)...  But it's not really
a big issue, since - usually anyway - if one uses resume=, it means
the machine in question isn't some remote 100-miles-away, but it's
here, and it's ok to bypass the resume for recovery purposes.

Just some random thoughts.

/mjt
