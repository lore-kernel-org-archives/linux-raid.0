From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Mon, 13 Jun 2011 02:32:47 -0300
Message-ID: <BANLkTikqs6R9r9hRAPR5b4ErLf1xr8yBpQ@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
	<4DECF025.9040006@fnarfbargle.com>
	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
	<4DECF841.1060906@fnarfbargle.com>
	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
	<BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>
	<4DEDB8B7.2070708@fnarfbargle.com>
	<BANLkTimxsT+htp82Us9uVgSdFNgb0m4vkQ@mail.gmail.com>
	<4DEF258A.8090600@fnarfbargle.com>
	<BANLkTi=4uHhNS7+WfcmvVSY11kDWe-e7ZQ@mail.gmail.com>
	<4DEF2B59.7090408@fnarfbargle.com>
	<BANLkTi=BuXK4SBGR=FrEcHFC1WohNkUY7g@mail.gmail.com>
	<4DEF7775.5020407@fnarfbargle.com>
	<BANLkTin8dpbxWfSCG_VoOM_FMmqCkm2mJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTin8dpbxWfSCG_VoOM_FMmqCkm2mJg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Folks,

On Wed, Jun 8, 2011 at 10:21 AM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
>
> Best of luck, and let us know how you get on.

Just finished the process here. To summarize, seems I've got my array
back in a stable state.

What I did:

1) Got a good backup of all the data in the array (using "tar") to
=A0=A0 removable HDs, verified it (using md5sum), and then stored these
=A0=A0 HDs safely offline;

2) Unmounted the filesystem in the array;

3) inserted the replacement disk on a USB dock, partitioned it,
=A0=A0 then added it to the array ("mdadm --add");
=A0=A0=A0 -> Verified (via "mdadm --detail") that the replacement disk =
was
=A0 =A0 =A0 =A0listed on the array as a "spare";

4) failed the bad disk in the array ("mdadm --fail")
=A0=A0 -> At that point, the array immediatelly started to resync into =
the
=A0=A0=A0=A0=A0 replacement disk;

5) Monitored the resync process via "cat /proc/mdstat": it took
=A0=A0 roughly 11 hours (I guess because transfer speed to the replacem=
ent
=A0=A0 disk was limited by the USB ~40MB/s speed limit), but it signale=
d
=A0=A0 no errors;

6) Verified that the array was really synced ("mdadm --detail") and
=A0=A0 that there were indeed no errors during the resync (less
=A0=A0 /var/log/messages);

7) removed the bad disk logically from the array ("mdadm --remove");

8) shut down the machine (init 0);

9) removed the bad disk physically from the machine, ejected the
=A0=A0 replacement disk from the USB dock, and then installed the
=A0=A0 replacement disk inside the machine;

10) turned the system on: the OS booted, assembled the array and
=A0=A0=A0 mounted the filesystem in it with no issues;

11) checked (using "md5sum -c" on the md5sum files generated during
=A0=A0=A0 pass#1 above) that all that ON THE ARRAY was indeed correct, =
so
=A0=A0=A0 in the end I didn't need to restore anything from backup.

Thanks for all the help, folks, and I pray we have the "hot-replace"
functionality implemented soon... it will make for much sounder sleep
the next time one of my disks fails... :-)

Cheers,
--
=A0 Durval Menezes.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
