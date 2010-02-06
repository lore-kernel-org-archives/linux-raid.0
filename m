From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Sat, 6 Feb 2010 14:06:46 -0800
Message-ID: <4877c76c1002061406h1d378552q75e6a33b73b29aad@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-3-git-send-email-dledford@redhat.com>
	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>
	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com>
	 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	 <4B6DAC06.6060909@redhat.com>
	 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
	 <20100206214640.GB20587@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100206214640.GB20587@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, initramfs@vger.kernel.org, Michal Marek <mmarek@su>
List-Id: linux-raid.ids

On Sat, Feb 6, 2010 at 1:46 PM, martin f krafft <madduck@debian.org> wr=
ote:
> also sprach Dan Williams <dan.j.williams@intel.com> [2010.02.07.1007 =
+1300]:
>> This comment makes me see Neil's argument in a different light,
>> (hopefully I am not mischaracterizing it), but essentially we are
>> waiting for the standards to catch up with this new class of
>> program. FUSE, CUSE, and mdmon belong to a class of programs that
>> move traditionally exclusive kernel space functionality to
>> userspace. Debian's /lib/init/rw looks to be a response to this
>> grey area of the standards (not that I have any familiarity with
>> the LSB).
>
> I have not read the full thread for lack of time, but I would like
> to chime in that I favour user-space over kernel-space any day: it
> makes for stabler systems, better interfaces, and easier upgrades
> =97 even though it's definitely more work for the distro maintainers.
>
> So mdmon seems like a good idea, even though some details might need
> to be worked out to everyone's satisfaction yet.
>
> I agree with Dan that this trend is new and that slow-moving
> standards like the FHS have yet to catch up. But they cannot catch
> up if distros don't explore the field. Debian's latest move in this
> exploration was indeed /lib/init/rw, but it's questionable, not only
> because it's a tmpfs, which makes it unusable for e.g. md bitmaps
> =97 unless we invented a place that moved to persistent storage as
> early as possible, in a way that would make it accessible early
> during the next boot. But now I am diverting the topic=85
>
> --
> =A0.''`. =A0 martin f. krafft <madduck@d.o> =A0 =A0 =A0Related projec=
ts:
> : :' =A0: =A0proud Debian developer =A0 =A0 =A0 =A0 =A0 =A0 =A0 http:=
//debiansystem.info
> `. `'` =A0 http://people.debian.org/~madduck =A0 =A0http://vcs-pkg.or=
g
> =A0`- =A0Debian - when you have better things to do than fixing syste=
ms
>
> "there are two major products that come out of berkeley: lsd and unix=
=2E
> =A0we don't believe this to be a coincidence."
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 -- jeremy s. anderson
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEAREDAAYFAktt40AACgkQIgvIgzMMSnX4fQCgsyGhAdpfuObqWlkmBLNFI/jO
> YxQAniFBRkITdqXjkkx1VgkHHNCJDbO2
> =3DtLKB
> -----END PGP SIGNATURE-----
>
>

Shouldn't all /state/ information be held in the kernel in some form
and exported via one of the virtual filesystems? (dev, proc, sysfs)

This way if some userspace need exists the file can be read.  If some
kernel access is required it's already within known structures.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
