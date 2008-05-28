From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Wed, 28 May 2008 11:46:16 -0500
Message-ID: <20080528164616.GB29722@atlantis.cc.ndsu.NoDak.edu>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens =?iso-8859-1?Q?B=E4ckman?= <jens.backman@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Wed, May 28, 2008 at 06:34:00PM +0200, Jens B=E4ckman wrote:

> Either the RAID 1 read speed must be wrong, or something is odd in th=
e
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.

The RAID 1 read speed metrics do not depict multithreaded
processes reading from the array simutaneouly. I would suspect
that the read performance metrics would look better if 2 bonnie
simulations were ran together (for RAID 1 that is).

Bryan=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
