From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Unable to stop array
Date: Mon, 8 Jun 2009 07:01:21 +0200
Message-ID: <20090608050121.GB6664@boogie.lpds.sztaki.hu>
References: <953048308fa5f94ed5dfd3f2c37a3767.squirrel@neil.brown.name> <20090608013744436.FBVG26412@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090608013744436.FBVG26412@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 07, 2009 at 08:37:47PM -0500, Leslie Rhorer wrote:

> It seems to me this is reproducible whenever the mount is used for an NFS
> share.  Even after unmounting the share on the remote system, the umount
> command won't release the mount on the local system unless one issues the -l
> switch, and then the array still won't stop.

You must unexport the NFS share first. You can not stop the RAID device
until the file system is unmounted, and you cannot unmount it until the
NFS export is gone. umount said you the file system is still in use; by
passing "-l" you said you do not care. But the kernel (including the
RAID device) _does_ care.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
