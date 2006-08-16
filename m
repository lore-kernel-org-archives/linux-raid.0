From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Wed, 16 Aug 2006 12:02:18 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0608161154390.15328@lion.drogon.net>
References: <44E250CD.5040308@aol.com> <Pine.LNX.4.56.0608160755090.15328@lion.drogon.net>
 <44E2EE20.9010004@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44E2EE20.9010004@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Aug 2006, andy liebman wrote:

> Thanks Gordon,
>
> I may not have been clear what I was asking. I wanted to know if you can
> make DISK IMAGES -- for example, with a program like Norton Ghost or
> Acronis True Image (better) -- of EACH of the two OS drives from a
> mirrored pair. Then restore Image A to one new disk, Image B to another
> disk. And then have a new working mirrored pair.

Right (I think) so at the end of the day, you want N servers each with a
pair of mirrored drives in it, or do you want N servers each with one
drive in it? I was assuming N servers with a pair of mirrored drives, all
setup identically...

> There is absolutely NO PROBLEM making images of single disks and
> restoring them to new disks (thus, creating clones). And it is very
> fast. For an OS drive with about 4 GBs of data, it only takes about 5
> minutes to make the image and 3 to restore it. So, after making the
> first set of images, it would in theory take under 10 minutes to restore
> a mirrored pair.

Imaging a partition or whole drive can be done with 'dd', but the
partition/drive needs to be offline or read-only when you do this or
you'll miss the filesystem cache and end up copying incorrect data. What
you can do is fill the partition (if it's a file system) with zeros; dd
if=/dev/zero of=bigfile ; rm bigfile, then feed it through gzip to make
the image smaller if desierd.

> I'm just trying to find out if there would be any "gotchas" in restoring
> mirrored drives. I can't think of any, but you never know. I'm not
> worried about hostnames. That's easy to fix.

Other than losing data you put in the drives after you made the clone, I
don't think so, but I may still be a little confused as to what you are
trying to achieve though ...

Gordon
