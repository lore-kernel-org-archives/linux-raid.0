From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Proposed Enhancements to MD
Date: Tue, 13 Jan 2004 08:19:32 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113081932.A721@lists.us.dell.com>
References: <40036902.8080403@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40036902.8080403@adaptec.com>; from scott_long@adaptec.com on Mon, Jan 12, 2004 at 08:41:54PM -0700
To: Scott Long <scott_long@adaptec.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 12, 2004 at 08:41:54PM -0700, Scott Long wrote:
> - DDF Metadata support: Future products will use the 'DDF' on-disk
>    metadata scheme.  These products will be bootable by the BIOS, but
>    must have DDF support in the OS.  This will plug into the abstraction
>    mentioned above.

For those unfamiliar with DDF (Disk Data Format), it is a Storage
Networking Industry Association (SNIA) project ("Common RAID DDF
TWG"), designed to provide a single metadata format to be used by all
the RAID vendors (hardware and software alike).  It removes vendor
lock-in by having a metadata format that all can use, thus in theory
you could move disks from an Adaptec hardware RAID controller to an
LSI software RAID solution without reformatting the disks or touching
your file systems in any way.  Dell has been championing the DDF
concept for quite a while, and is driving vendors from which we
purchase RAID solutions to use DDF instead of their own individual
metadata formats.

I haven't seen the spec yet myself, but I'm lead to believe that
DDF allows for multiple logical drives to be created across a single
set of disks (e.g. a 10GB RAID1 LD and a 140GB RAID0 LD together on
two 80GB spindles), as well as whole disks be used.  It has a
mechanism to support reconstruction checkpointing, so you don't have
to restart a reconstruct from the beginning after a reboot, but from
where you left off.  And other useful features too that you'd expect
in a common RAID solution.  

DDF is quickly becoming important to RAID and system vendors, and I
welcome Adaptec's work to implement DDF support on Linux.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
