From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm PATCH 00/13] rebuild / resync checkpointing and other
	external metadata fixes
Date: Tue, 22 Dec 2009 17:13:06 -0700
Message-ID: <e9c3a7c20912221613y33db84bfpb009bbdfe481e3c0@mail.gmail.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

On Tue, Dec 22, 2009 at 4:59 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> Hi Neil,
>
> The latter half of this update consumes the new
> md/dev-XXX/recovery_start attribute for checkpointing and resuming
> resync/rebuild operations. =A0It requires one more kernel patch [1] o=
n top
> of 2.6.33-rc1 to ensure that mdmon sees the recovery state. =A0One ca=
veat
> is that we only get checkpoint events when the sync_action =3D=3D idl=
e, at
> array shutdown or as a part of 'mdadm --wait-clean --scan'.
>
> The other bits are a collection of fixes to address unrelated issues
> discovered along the way. =A0The result is pushed out to:
>
>        git://github.com:djbw/mdadm.git master

That ':' should be a '/'

        git://github.com/djbw/mdadm.git master
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
