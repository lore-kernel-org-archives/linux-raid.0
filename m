From: "Brian C. Lane" <bcl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] Add nonfs partition type 0xda
 (#1263835)
Date: Fri, 9 Oct 2015 09:21:11 -0700
Message-ID: <20151009162111.GR2984@lister.brianlane.com>
References: <1443654419-3714-1-git-send-email-bcl@redhat.com>
 <560EB887.6060302@ubuntu.com>
 <20151008214916.GK2984@lister.brianlane.com>
 <5617D701.1010109@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5617D701.1010109-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.alioth.debian.org/cgi-bin/mailman/options/parted-devel>,
 <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.alioth.debian.org/pipermail/parted-devel/>
List-Post: <mailto:parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Help: <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=help>
List-Subscribe: <http://lists.alioth.debian.org/cgi-bin/mailman/listinfo/parted-devel>,
 <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=subscribe>
Errors-To: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
Sender: "parted-devel"
 <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
To: Phil Susi <psusi-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
List-Id: linux-raid.ids

On Fri, Oct 09, 2015 at 11:02:25AM -0400, Phil Susi wrote:
> On 10/8/2015 5:49 PM, Brian C. Lane wrote:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1118065 has a pile of
> > discussion on it.
> > 
> > What it amounts to is that on msdos partitioned disks mdadm only wants
> > 0xfd to be used for version 0.90 arrays which the kernel can
> > autoassemble, for 1.x arrays some other type needs to be used.
> 
> So use 0x80?  That's what I always have done and it has never been a
> problem.  Likewise, 0xfd won't cause a problem either: it will trigger
> kernel auto activation *if* you boot with no initramfs, *and* the
> partition does contain 0.90 metadata.  If it has 1.x, then it won't
> trigger auto activation, but has no other negative consequence.
> 
> I see from the discussion in that bug report that the mdadm man page
> recommends this type code.  Is there any reason for that recommendation?
>  Are there any consequences to not following it?  Cc'ing mdadm list to
> see if they can answer this.
> 

I think their thinking is that 0x80 implies a filesystem.

I really don't see any harm in adding it, if you don't want to use it,
don't.

-- 
Brian C. Lane | Anaconda Team | IRC: bcl #anaconda | Port Orchard, WA (PST8PDT)
