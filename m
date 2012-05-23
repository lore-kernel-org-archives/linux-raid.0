From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: Re: SSSE6 / RAID6
Date: Tue, 22 May 2012 17:26:55 -0700
Message-ID: <20120523002655.GA2701@jtkukuna_gentoo_sb.jf.intel.com>
References: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
 <4FBC10AC.3000803@zytor.com>
 <CADNH=7HtXPqwe_MDPg=hwPTjFgBUcXkyv3WkhZyJ2cpv4J1aqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADNH=7HtXPqwe_MDPg=hwPTjFgBUcXkyv3WkhZyJ2cpv4J1aqA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 23, 2012 at 12:37:32AM +0100, Mathias Bur=E9n wrote:
> On 22 May 2012 23:18, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 05/22/2012 02:27 PM, Mathias Bur=E9n wrote:
> >> Hi list,
> >>
> >> I just compiled 3.4 for my little Atom box. Is there any way I can
> >> confirm if the RAID6 check is using SSSE6 instructions?

<snip>

The _SSSE3_ RAID6 recovery functions are in Neil's for-next tree. They =
aren't
in 3.4.

If they were, you'd see something like:

% dmesg | grep ssse3
[    0.167849] raid6: using ssse3x1 recovery algorithm


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jim Kukunas
Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
