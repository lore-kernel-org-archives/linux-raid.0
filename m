From: David =?iso-8859-1?Q?H=E4rdeman?= <david@2gen.com>
Subject: Hardware RAID recommendation
Date: Mon, 25 Oct 2004 19:43:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025174347.GB14120@hardeman.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm currently considering which hardware RAID controller to buy and=20
I've spent some time researching different cards. However, it's hard to=
=20
get a good idea about the available software for the different cards.

Some seems to only have Windows-based software (which means that the=20
BIOS setup must be used for all tasks which kind of defeats the purpose=
=20
of the RAID setup), some seems to have weird, awkward, closed-source,=20
certified-to-work-on-redhat-only software and so on.

So my question is if there is a hardware SCSI RAID solution that allows=
=20
all essential features to be monitored and controlled. Essential=20
features would mean such things as online expansion, designating spare=20
disks, creating new RAID sets, checking status, deleting RAID sets, etc=
=2E

So far I'm leaning towards the LSI MegaRaid 320-1 controller, but so fa=
r=20
I've only seen the megamgr/megamon software from LSI (which seems very=20
non-open and redhat specific) and reading values from /proc (which=20
pretty much excludes only monitoring, no control) as alternatives.

So, basically I'm looking for some feedback on how people manage their=20
hardware RAID controllers under Linux.

Please CC me on any replies as I'm not subscribed to the list...

Re,
David H=E4rdeman
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
