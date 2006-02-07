From: Luca Berra <bluca@comedia.it>
Subject: Re: [klibc] Re: Exporting which partitions to md-configure
Date: Tue, 7 Feb 2006 11:43:11 +0100
Message-ID: <20060207104311.GD22221@percy.comedia.it>
References: <43DEB4B8.5040607@zytor.com> <17374.47368.715991.422607@cse.unsw.edu.au> <43DEC095.2090507@zytor.com> <17374.50399.1898.458649@cse.unsw.edu.au> <43DEC5DC.1030709@zytor.com> <17382.43646.567406.987585@cse.unsw.edu.au> <43E80A5A.5040002@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43E80A5A.5040002@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 06, 2006 at 06:47:54PM -0800, H. Peter Anvin wrote:
>Neil Brown wrote:
>Requiring that mdadm.conf describes the actual state of all volumes 
>would be an enormous step in the wrong direction.  Right now, the Linux 
>md system can handle some very oddball hardware changes (such as on 
>hera.kernel.org, when the disks not just completely changed names due to 
>a controller change, but changed from hd* to sd*!)
DEVICE partitions
ARRAY /dev/md0 UUID=xxyy:zzyy:aabb:ccdd

would catch that


>Dynamicity is a good thing, although it needs to be harnessed.
>
> > kernel parameter md_root_uuid=xxyy:zzyy:aabb:ccdd...
> >    This could be interpreted by an initramfs script to run mdadm
> >    to find and assemble the array with that uuid.  The uuid of
> >    each array is reasonably unique.
I could change mdassemble to allow accepting an uuid on the command line
and assemble a /dev/md0 with the specified uuid (at the moment it only
accepts a configuration file, which i tought was enough for
initrd/initramfs.

>This, in fact is *EXACTLY* what we're talking about; it does require 
>autoassemble.  Why do we care about the partition types at all?  The 
>reason is that since the md superblock is at the end, it doesn't get 
>automatically wiped if the partition is used as a raw filesystem, and so 
>it's important that there is a qualifier for it.
I don't like using partition type as a qualifier, there is people who do
not wish to partition their drives, there are systems not supporting
msdos like partitions, heck even m$ is migrating away from those.

In any case if that has to be done it should be done into mdadm, not
in a different scrip that is going to call mdadm (behaviour should be
consistent between mdadm invoked by initramfs and mdadm invoked on a
running system).

If the user wants to reutilize a device that was previously a member of
an md array he/she should use mdadm --zero-superblock to remove the
superblock.
I see no point in having a system that tries to compensate for users not
following correct procedures. sorry.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
