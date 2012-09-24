From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 15:17:47 -0300
Message-ID: <CABYL=Try-XyEEXe37RWt4Py8_ewh-mU2kAn1X_75FjrLFcACeQ@mail.gmail.com>
References: <4961154.0TR9MeFlIq@techz>
	<2627519.Y2VdWh5VBI@techz>
	<1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com>
	<1361158.MkTZ6QR6cp@techz>
	<E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com>
	<3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
	<505DD9E2.7090908@anonymous.org.uk>
	<F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com>
	<505E368A.4020200@anonymous.org.uk>
	<6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com>
	<505EF9F3.7000908@anonymous.org.uk>
	<142B3AEB-45FE-4A6E-A03F-BEAA9599C2DC@colorremedies.com>
	<D14F019C-39C6-4C60-88EF-A7565FA93D6F@colorremedies.com>
	<506029DB.3080407@anonymous.org.uk>
	<8AB64122-6198-4A2E-BA49-76BD6AFE7907@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8AB64122-6198-4A2E-BA49-76BD6AFE7907@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i used some disks one or two years ago of 1.5TB, when i boot the disk
for the first time the bios recognized it as a 1TB disk, i change some
bios parameters (removed from automatic) and i could put it to work
with 1.5TB could you check if it=B4s a bios problem? in my case the dis=
k
appears as 1TB when it booted wrong, and after changing bios options
it goes nice with 1.5TB


2012/9/24 Chris Murphy <lists@colorremedies.com>
>
>
> On Sep 24, 2012, at 3:37 AM, John Robinson wrote:
>
> > On 23/09/2012 19:53, Chris Murphy wrote:
> > [...]
> >> Upon creating a GPT on /dev/md/vol0, identical structures at ident=
ical byte offsets are created on /dev/sd[bc] and /dev/md/vol0.
> >>
> >> The primary GPT header says the alternate header is at 0xffdfff.
> >> The alternate GPT header is at 0xffdfff., or sector 16769023, righ=
t where it should be.
> >>
> >> Regardless of whether the kernel sees the disk as Intel RAID or a =
bare disk, it finds the alternate GPT header, and doesn't complain abou=
t anything.
> >
> > Yes, it does. It finds the alternate header just fine, according to=
 the offset in the primary header, but warns that it's not at the end o=
f the disc, which is where it expected to find it:
>
> Not for me, is what I meant. Linux 3.5.3-1.fc17 does not complain abo=
ut the alternate GPT header not being at the end of the disk. However, =
parted 3.0 does. And gdisk 0.8.5 does not.
>
> Further, it seems increasingly clear as I'm reading the UEFI spec on =
GPT, that IMSM is incompatible with GPT. The GPT alternate header by sp=
ec is expected at the end of the disk, but then IMSM also demands to be=
 in basically the exact same location. And yet Intel is shipping UEFI h=
ardware, which require GPT disks, with IMSM on board that also requires=
 metadata in the same location? How is this not a WTF moment?
>
> I'm still wondering why parted reports G=FCnther's disks have hybrid =
MBRs. That's weird, even if unrelated. And I wonder why his kernel comp=
lains about the GPTs not being at the end of the disk, but my kernel do=
esn't. Both are 3.5 kernels.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
