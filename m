From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: i just read in the archive.........
Date: Fri, 14 Jun 2002 12:21:08 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020614122108.J19520@mea-ext.zmailer.org>
References: <1024044823.2250.15.camel@Asterix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1024044823.2250.15.camel@Asterix>; from loic.paillotin@qualimucho.com on Fri, Jun 14, 2002 at 10:53:43AM +0200
To: =?iso-8859-1?Q?Lo=EFc_Paillotin?= <loic.paillotin@qualimucho.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 14, 2002 at 10:53:43AM +0200, Lo=EFc Paillotin wrote:
> I justy read in the archive that software raid would'nt work with ext=
3
> file system. Is that true ? ( i mean is that still true? )=20

  RAID1 + EXT3 + SMP used to be a recipe for a deadlock, right now I am
  not quite sure.  I am running one SMP machine with IDE disks with
  kernel  2.4.19-pre8smp  and that hasn't groaked with saturation tests=
=2E

  Hmm..  I am not sure that I have done saturation testing with that
  new kernel either, but it contains a bunch of EXT3 fixes, which
  might help.

  What is definite is that RAID1 + EXT3 with UNIPROCESSOR KERNEL
  (even if machine has multiple processors) does not deadlock.

  So, if you are willing to run with uniprocessor kernel (effectively
  to ditch additional CPUs at your SMP box), you will be safe.

  If you want to test deadlocking (at a SMP machine with SMP kernel),
  you can do it with:

        dd if=3D/dev/zero bs=3D1024k of=3Dtest.file count=3D6000

  Choose the count to be at least 2-3 times the amount of memory
  in your machine.

  If that doesn't deadlock, you are safe.

> --=20
> Lo=EFc Paillotin

/Matti Aarnio
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
