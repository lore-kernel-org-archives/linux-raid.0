From: Phil Susi <psusi@ubuntu.com>
Subject: Re: [parted-devel] [PATCH 1/2] Add nonfs partition type 0xda
 (#1263835)
Date: Fri, 9 Oct 2015 11:02:25 -0400
Message-ID: <5617D701.1010109@ubuntu.com>
References: <1443654419-3714-1-git-send-email-bcl@redhat.com>
 <560EB887.6060302@ubuntu.com> <20151008214916.GK2984@lister.brianlane.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151008214916.GK2984@lister.brianlane.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Brian C. Lane" <bcl@redhat.com>
Cc: parted-devel@lists.alioth.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/8/2015 5:49 PM, Brian C. Lane wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=1118065 has a pile of
> discussion on it.
> 
> What it amounts to is that on msdos partitioned disks mdadm only wants
> 0xfd to be used for version 0.90 arrays which the kernel can
> autoassemble, for 1.x arrays some other type needs to be used.

So use 0x80?  That's what I always have done and it has never been a
problem.  Likewise, 0xfd won't cause a problem either: it will trigger
kernel auto activation *if* you boot with no initramfs, *and* the
partition does contain 0.90 metadata.  If it has 1.x, then it won't
trigger auto activation, but has no other negative consequence.

I see from the discussion in that bug report that the mdadm man page
recommends this type code.  Is there any reason for that recommendation?
 Are there any consequences to not following it?  Cc'ing mdadm list to
see if they can answer this.

