From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 09:46:15 -0300
Message-ID: <BANLkTi=ttUwZZ-NqxPE0QquHx0bBj4jjsA@mail.gmail.com>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
	<alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
	<20110629204519.419474d2@notabene.brown>
	<alpine.OSX.2.00.1106291206390.257@trogdor.csi.cam.ac.uk>
	<BANLkTikcN9vy1-SeYONZkGmDTH9ikea=4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikcN9vy1-SeYONZkGmDTH9ikea=4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

some ideas....

maybe for a test only...
we could send trim commands on raid1 arrays only or 'raid0 linear'
since they don=B4t stripe, this could be 'easy' to develop
when filesystem send trim, we send it to down device (/dev/sdX99)
there=B4s a problem of offset (for raid1) maybe some devices just work
with 4096bytes blocks on trim command, maybe not
we could implement and put in a beta/alpha realease to test like ext4
guys are doing with discard command (it=B4s a user option today)


2011/6/29 Scott E. Armitage <launchpad@scott.armitage.name>:
> On Wed, Jun 29, 2011 at 7:10 AM, Tom De Mulder <tdm27@cam.ac.uk> wrot=
e:
>> However, that might not necessarily be a problem; tools exist that c=
an be run manually (slightly fsck-like) and tell the drive which blocks=
 can be erased.
>
> For RAID5/6 at least, md will still require knowledge of what stripes
> are and are not in use by the filesystem. In the current
> implementation, the entire array must be consistent, regardless of
> whether or not a particular block is in use. As far as my
> understanding goes, any level of TRIM support for parity arrays would
> be a fundamental shift in the way md treats the array.
>
> The simplest solution I see is to do as Niel suggested, and mimic TRI=
M
> support at the RAID level, and pass commands down as necessary. An
> alternative solution would be to add a second TRIM layer, where md
> maintains a list of what is or is not in use, and once an entire
> stripe has been discarded by the filesystem, it can send a single TRI=
M
> command to each member drive to drop the entire stripe contents. This
> adds abstraction for the filesystem layer, allowing it to treat the
> RAID array like a regular SSD, but adds significant complexity to md
> itself.
>
> -Scott
>
> p.s. Sorry if you receive this twice; Majordomo rejected the first on=
e
> on HTML subpart basis.
>
> --
> Scott Armitage, B.A.Sc., M.A.Sc. candidate
> Space Flight Laboratory
> University of Toronto Institute for Aerospace Studies
> 4925 Dufferin Street, Toronto, Ontario, Canada, M3H 5T6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
