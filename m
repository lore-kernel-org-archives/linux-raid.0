From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Fri, 22 May 2009 00:53:28 -0700
Message-ID: <e9c3a7c20905220053l2cd83120y5e6c6ac9a0e4ef80@mail.gmail.com>
References: <1241300764.5607.36.camel@raz>
	 <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
	 <18965.16276.485692.812516@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18965.16276.485692.812516@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Thu, May 21, 2009 at 4:48 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday May 19, dan.j.williams@intel.com wrote:
>> On Sat, May 2, 2009 at 2:46 PM, raz ben yehuda <raziebe@013.net> wro=
te:
> =A0- Surely RAID0 is (like LVM) just a legacy idea until we get sensi=
ble
> =A0 file systems that actually understand multiple devices and do all
> =A0 this stuff for you are a more sensible level - so why are we
> =A0 busting a gut(*) to make RAID0 work well?? =A0Answer is of course
> =A0 that no-one has made a sensible file system yet. (well... maybe z=
fs
> =A0 or btrfs, not sure)

"Compatibility" is another cause of the abdominal pressure.  See the
single drive to raid0 migrations supported by the Windows driver:
http://www.intel.com/support/chipsets/imsm/sb/cs-020674.htm

> So: lots of thoughts, some pointing in different directions.
> But I'm not against reshape code appearing in RAID0 providing it is
> well designed, maintainable, reliable, and doesn't slow down normal
> RAID0 processing. =A0I suspect we can get there.

Nod.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
