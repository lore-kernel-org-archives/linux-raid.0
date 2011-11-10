From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 11:42:01 -0500
Message-ID: <CALJXSJpo4pY4xC3h_Z3vDHW6Piwfqz0amhgOc+VtZG2=v_fUOQ@mail.gmail.com>
References: <4EBBF60F.4030606@northfolk.ca>
	<CALJXSJrdBX8xqkwamauRsz27LUQYg-gV-G4K+RrNkdhB5ki31w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJrdBX8xqkwamauRsz27LUQYg-gV-G4K+RrNkdhB5ki31w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Nov 10, 2011 at 11:04 AM, Chris Purves <chris@northfolk.ca> wro=
te:
> I can bring the array back up in degraded mode by running mdadm --ass=
emble --force /dev/md1; however, I have been unable to build the fifth =
disk. =C2=A0I would appreciate any help.

The best way to proceed would be with the array down, you can ddrescue
the semi-good disk to a new good disk, then start the array and
recover by adding a new disk to the array.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
