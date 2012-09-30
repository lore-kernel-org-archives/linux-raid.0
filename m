From: EJ Vincent <ej@ejane.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Sun, 30 Sep 2012 19:23:16 -0400
Message-ID: <5068D464.4030504@ejane.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org> <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com> <50689C9B.1010603@ejane.org> <5068AB81.1060103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5068AB81.1060103@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/30/2012 4:28 PM, Phil Turmel wrote:
> On 09/30/2012 03:25 PM, EJ Vincent wrote:
>> On 9/30/2012 3:22 PM, Mathias Bur=C3=A9n wrote:
>>> Can't you just boot off an older Ubuntu USB, install mdadm and scan=
 /
>>> assemble, see the device order?
>> Hi Mathias,
>>
>> I'm under the impression that damage to the metadata has already bee=
n
>> done by 12.04, making a recovery from an older version of Ubuntu
>> (10.04), impossible.  Is this line of thinking, flawed?
> Your impression is correct.  Permanent damage to the metadata was don=
e.
>   You *must* re-create your array.
>
> However, you *cannot* use your new version of mdadm, as it will get t=
he
> data offset wrong.  Your first report showed a data offset of 272.
> Newer versions of mdadm default to 2048.  You *must* perform all of y=
our
> "mdadm --create --assume-clean" permutations with 10.04.
>
> Do you have *any* dmesg output from the old system?  Or dmesg from th=
e
> very first boot under 12.04?  That might have enough information to
> shorten your search.
>
> In the future, you should record your setup by saving the output of
> "mdadm -D" on each array, "mdadm -E" on each member device, and the
> output of "ls -l /dev/disk/by-id/"
>
> Or try my documentation script "lsdrv". [1]
>
> HTH,
>
> Phil
>
> [1] http://github.com/pturmel/lsdrv
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Phil,

Unfortunately I don't have any dmesg log from the old system or the=20
first boot under 12.04.

Getting my system to boot at all under 12.04 was chaotic enough, with=20
the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-function=
s=20
ravaging my array and then dropping me to a busybox shell over and over=
=20
again.  I didn't think to record the very first error.

Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and=20
/dev/sdj1 don't have the Raid level "-unknown-", neither are they=20
labeled as spares.  They are in fact, labeled clean and appear=20
*different* from the others.

Could these disks still contain my metadata from 10.04?  I recall durin=
g=20
my installation of 12.04 I had anywhere from 1 to 3 disks unpowered, so=
=20
that I could drop in a SATA CD/DVDRW into the slot.

I am downloading 10.04.4 LTS and will be ready to use it soon.  I fear=20
having to do permutations-- 9! (factorial) would mean 362,880=20
combinations.  *gasp*

Many thanks for all your comments and insights.

-EJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
