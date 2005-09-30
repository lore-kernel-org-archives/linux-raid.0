From: Matthew Coulson <jmcoulson@gmail.com>
Subject: Re: Shrinking on-disk size of RAID1 array?
Date: Fri, 30 Sep 2005 10:32:47 +0100
Message-ID: <63d08afd0509300232u36141930h@mail.gmail.com>
References: <433CD4FA.6010603@bitzi.com>
Reply-To: Matthew Coulson <jmcoulson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <433CD4FA.6010603@bitzi.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm hoping to shrink the per-component size of an active RAID1
> array, so that I can transition the array to a smaller, faster
> set of drives.

I may be missing something here, but why not connect up the new
drives, setup the arrays, simply cp -R * everything over to the new
filesystems and update fstab and mdadm.conf? I can understand wanting
to let the system handle it all for you, but this way you'll get a
free defrag to boot :)
