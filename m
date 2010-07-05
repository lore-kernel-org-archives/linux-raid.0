From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 29/33] update for early rules to support --grab
Date: Mon, 5 Jul 2010 11:50:34 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC42F@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C5A@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C5A@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:43 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 29/33] update for early rules to support --grab

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0udev-early-md.rules |=A0=A0=A0 2 +-
=A01 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/udev-early-md.rules b/udev-early-md.rules index 176ad61..3=
433953 100644
--- a/udev-early-md.rules
+++ b/udev-early-md.rules
@@ -16,7 +16,7 @@ ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", GOTO=3D"md_=
end"
=A0# do something with this device if it determines that it should own =
it.
=A0# That allows us to program in whatever smarts are needed into mdadm=
,=A0 # but at the expense of running mdadm on every blk device add|chan=
ge event :-( -IMPORT{program}=3D"/sbin/mdadm -I --new-device $tempnode"
+IMPORT{program}=3D"/sbin/mdadm -I -g /dev/$tempnode"
=A0ENV{MD_OWNED}!=3D"?*", GOTO=3D"md_end"
=A0# We owned the device, so have udev reset the database info in case =
we=A0 # changed it
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
