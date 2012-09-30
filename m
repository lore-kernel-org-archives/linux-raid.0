From: Phil Turmel <philip@turmel.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 16:28:49 -0400
Message-ID: <5068AB81.1060103@turmel.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org> <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com> <50689C9B.1010603@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50689C9B.1010603@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/30/2012 03:25 PM, EJ Vincent wrote:
> On 9/30/2012 3:22 PM, Mathias Bur=C3=A9n wrote:
>> Can't you just boot off an older Ubuntu USB, install mdadm and scan =
/
>> assemble, see the device order?
>=20
> Hi Mathias,
>=20
> I'm under the impression that damage to the metadata has already been
> done by 12.04, making a recovery from an older version of Ubuntu
> (10.04), impossible.  Is this line of thinking, flawed?

Your impression is correct.  Permanent damage to the metadata was done.
 You *must* re-create your array.

However, you *cannot* use your new version of mdadm, as it will get the
data offset wrong.  Your first report showed a data offset of 272.
Newer versions of mdadm default to 2048.  You *must* perform all of you=
r
"mdadm --create --assume-clean" permutations with 10.04.

Do you have *any* dmesg output from the old system?  Or dmesg from the
very first boot under 12.04?  That might have enough information to
shorten your search.

In the future, you should record your setup by saving the output of
"mdadm -D" on each array, "mdadm -E" on each member device, and the
output of "ls -l /dev/disk/by-id/"

Or try my documentation script "lsdrv". [1]

HTH,

Phil

[1] http://github.com/pturmel/lsdrv

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
