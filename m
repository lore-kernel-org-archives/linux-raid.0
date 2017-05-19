From: Victor Helmholtz <victor.helmholtz@gmail.com>
Subject: Re: How to backup of large md raid volumes?
Date: Fri, 19 May 2017 04:59:02 +0100
Message-ID: <62E42E7D-598A-4DBD-BBED-5A61F6A57516@gmail.com>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> On 18 May 2017, at 22:37, Ram Ramesh <rramesh2400@gmail.com> wrote:
>=20
> Any one have a method to backup large volumes like md raid6 (16TB)? =
Since the backup will not fit in one disk (in many cases and mine too) I =
am wondering, if there is a known/easy technique to backup using =
multiple usb hard drives. I googed and found a few fancy backup =
utils/systems like Amanda etc. They are overkill for me. I am choosing =
not to back up simply because of the complexity of setup as the data in =
my RAID volume is NOT precious and can be replaced with a week of =
effort.
>=20
> If any one can think of some thing simple, please point me to it and I =
will do the reading to figure out.
>=20
> Thanks
> Ramesh
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

If you are looking for the simplest solution you can use tar with =
--multi-volume option. I use it to create tape backups, but it can be =
used with hard drives as well. Detailed description of this tar option =
is available at =
https://www.gnu.org/software/tar/manual/html_section/tar_79.html

Regards
Victor=
