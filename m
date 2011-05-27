From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 08:06:11 -0400
Message-ID: <4DDF93B3.8060101@turmel.org>
References: <42.A9.00666.D9CEEDD4@cdptpa-omtalb.mail.rr.com>	<4DDEED47.1040809@fnarfbargle.com> <20110527095840.427d90be@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110527095840.427d90be@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Brad Campbell <brad@fnarfbargle.com>, lrhorer@satx.rr.com, =?ISO-8859-1?Q?=27Mathias_Bur=E9n=27?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org, =?ISO-8859-1?Q?Torbj=F8rn_Skagestad?= <torbjorn@itpas.no>
List-Id: linux-raid.ids

On 05/26/2011 11:58 PM, Roman Mamedov wrote:
> On Fri, 27 May 2011 08:16:07 +0800
> Brad Campbell <brad@fnarfbargle.com> wrote:
>=20
>> On 27/05/11 08:13, Leslie Rhorer wrote:
>>>>
>>> 	I can't speak to Ubuntu, but Debian evidently does not.  I don't
>>> know what "pvs" is, but neither bash nor Python recognize it as a f=
ile
>>> anywhere in the path.
>> apt-get install lvm2.
>=20
> Sure, but lsdrv shouldn't assume lvm2 is installed or require it to b=
e
> installed. Not everyone uses LVM, and simply installing it automatica=
lly adds
> things to initramfs (PV/VG/LV detection?), which can slow down boot-u=
p process.

With the latest contribution from Torbj=F8rn, lsdrv will now report the=
 missing utility, then continue.  If one of the devices is in fact an L=
VM element, the block device recursion code should still show the basic=
 relationships, without the volume group details.  Testing that case wo=
uld be appreciated.

https://github.com/pturmel/lsdrv

If you find more bugs, or have other suggestions, using the issue track=
er and the wiki on github would minimize the chatter on linux-raid.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
