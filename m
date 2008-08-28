From: Bernd Schubert <bs@q-leap.de>
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Thu, 28 Aug 2008 11:49:57 +0200
Message-ID: <200808281149.58005.bs@q-leap.de>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 28 August 2008 10:32:32 thomas62186218@aol.com wrote:
> Hi all,
>
> I am struggling with an issue on an Ubuntu 8.0.4 64-bit system. The
> system has 12 SATA drives. I create a RAID 5 array using mdadm as
> follows:
>
> mdadm -Cv /dev/md0 -n12 -l5 -c128 /dev/sd[b-m] -R -f
>
> The device creates successfully and starts and is visible as syncing =
in
> cat /proc/mdstat. But, according to mdadm -X /dev/md0, there is no md
> superblock on the device. Doing the same mdadm -X command for all

You need to run --detail for md devices

> components /dev/sdb through /dev/sdm shows superblocks. If I reboot t=
he

--examine only works for the components

> system, /dev/md0 is completely gone, and a mdadm --assemble --scan

Did you add the corresponding entries to your mdadm.conf?

See this chapter in "man 8 mdadm"

<quote>
         echo =E2=80=99DEVICE /dev/hd[a-z] /dev/sd*[a-z]=E2=80=99 > mda=
dm.conf
         mdadm --examine --scan --config=3Dmdadm.conf >> mdadm.conf
       This  will  find  arrays which could be assembled from existing =
IDE and=20
SCSI whole drives (not partitions),
       and store the information in the format of a config file.  This =
file is=20
very  likely  to  contain  unwanted
       detail, particularly the devices=3D entries.  It should be revie=
wed and=20
edited before being used as an actual
       config file.

</quote>


Cheers,
Bernd


--=20
Bernd Schubert
Q-Leap Networks GmbH
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
