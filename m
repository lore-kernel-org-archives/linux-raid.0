From: David Greaves <david@dgreaves.com>
Subject: Re: --no-degraded in mdadm.conf? / disable auto assembly
Date: Tue, 29 Apr 2008 14:02:47 +0100
Message-ID: <48171C77.3080206@dgreaves.com>
References: <200804291355.59052.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804291355.59052.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:
> How do I prevent mdadm from assembling any array at all without uninstalling 
> the package? I commented out all lines, still it seems it scanned and 
> assembled what it found.
> (Possibly a debian thing, will look into this)
AFAIK there are 3 places where an array is assembled 'automatically'

1. kernel auto-detect of 0xfd partitions - not mdadm, not currently preventable
AFAIK.
2. initrd mdadm script
3. init.d mdadm script

I'm not sure how udev figures into this... ISTR that some distros had udev
script issues when udev detected and assembled an array when it had found
'enough' components and then triggered a resync when the final component popped up.

> Next thing: I don't want mdadm to assemble arrays if not all disks are 
> present. Can I pass no-degraded to mdadm.conf?
Yes. man madadm:
       --no-degraded
              This is the reverse of --run in that it inhibits the started if
array unless all expected drives are present.  This
              is  only needed with --scan and can be used if you physical
connections to devices are not as reliable as you would
              like.

Of course it may be in a newer version :)
Where's the git page for mdadm then?

> Is there a dry-run-option that says what would happen if I assembled now?
Not AFAIK - plus, I think this would be an md function wouldn't it? Doesn't
mdadm just ask the kernel md module to assemble the components without checking
event counts etc.

David
