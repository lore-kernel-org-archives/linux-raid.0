From: "Mandar Joshi" <mandar.joshi@calsoftinc.com>
Subject: performance degrade with RAID6 against RAID0
Date: Thu, 21 Aug 2014 00:17:54 +0530
Message-ID: <005101cfbca7$419a3820$c4cea860$@calsoftinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
References: 
In-Reply-To: 
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 I want to know how much p=
erformance degrade (if any) is
expected when same disks-same config settings are used for RAID0 and RA=
ID6.

With the help of few mails on this mailing list and information availab=
le on
opensource, I tuned my disks/raid with which I got following,
Linux kernel used: 2.6.32 RHEL6.4

Underlying scsi devices config set at:
max_sectors_kb=3D8192, scheduler=3Dnoop (or deadline)
Buffered IO using xdd, dd:: block size=3D4MB, all sequential writes
IO done directly on md/raid device /dev/mdX

6 disks buffered IO total write speed =3D 1000 MBps i.e. around 165 MBp=
s per
disk

RAID0: 64KB chunk size 6 disks =3D 980 MBps i.e. around 164 MBps per di=
sk

RAID6: 64KB chunk size 6 (4 + 2) disks with stripe_cache_size =3D 8192,
preread_bypass_threshold =3D 8192. No pre-reads seen.
Gives=20
340 MBps i.e. around 85 MBps per data disks (4)
i.e. around 45-50% drop is seen.

Same IO tool and IO settings used for all 3 experiments.

In general, Is this much drop expected with RAID6 against same RAID 0
config?
If not, Is any configuration setting is missing?
If I could drive RAID0 with line speed should I expect same with RAID6 =
also.

Thanks in advance,
Mandar Joshi


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
