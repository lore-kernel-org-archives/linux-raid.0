From: Mikhail Yakshin <greycat@altlinux.org>
Subject: [ANNOUNCE] Einarc - universal RAID management/monitoring tool - v1.2
 released
Date: Mon, 09 Jun 2008 15:58:06 +0400
Message-ID: <484D1ACE.7030802@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I'm pleased to announce new release of Einarc project - an universal=20
RAID management/monitoring tool.

Version 1.2 had almost half a year development cycle and sports the=20
following new stuff:

     * Support for new RAID devices: newer Adaptec adapters using arcco=
nf.

     * New objects =E2=80=9Cbbu=E2=80=9D and =E2=80=9Cfirmware=E2=80=9D=
 are introduced: now it=E2=80=99s=20
possible to get information about BBU and read/write firmware to=20
supported adapters.

     * More strict =E2=80=9Cadapter info=E2=80=9D report: it outputs se=
rial number and=20
tries to pinpoint a particular adapter using PCI IDs, if possible.

     * Updates for existing devices:
           o aaccli: now it downloads and uses later, more acceptable=20
version, not linked against arts library. Note, however, that=20
Adaptec_Storage_Manager-Linux_v2.10.00 is a huge ~36M download.
           o areca: update to v1.80A_71012.
           o megacli: updated to v1.01.27.

     * Multiple stability, metadata and rare occurance fixes for all=20
modules.

     * Improved build system.

     * =E2=80=9Craid-wizard-passthrough=E2=80=9D can be used to handle =
smaller groups of=20
HDDs (not all available devices).

As always, I'd be really happy to hear any opinions / thoughts / featur=
e=20
requests on this project and I hope it would come useful to someone :)=20
Einarc can be reached at

http://www.inquisitor.ru/doc/einarc/

for downloading and documentation.

--=20
WBR, Mikhail Yakshin AKA GreyCat

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
