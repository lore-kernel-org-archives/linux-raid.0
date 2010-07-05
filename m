From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 28/33] update udev rules to support --path parameter with
 remove action
Date: Mon, 5 Jul 2010 11:50:16 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC42C@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C58@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C58@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:42 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 28/33] update udev rules to support --path parameter wi=
th remove action

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

in order to enable changes added in previous patches, udev needs to pas=
s <path-id> to mdadm. All "remove" actions of raid members has been upd=
ated with --path <path-id>.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0udev-md-raid.rules |=A0=A0=A0 4 ++--
=A01 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules index 712c5e5..052=
77c4 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -3,9 +3,9 @@
=A0SUBSYSTEM!=3D"block", GOTO=3D"md_end"
=A0
=A0# handle potential components of arrays -ENV{ID_FS_TYPE}=3D=3D"linux=
_raid_member", ACTION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"remove", RUN+=3D=
"/sbin/mdadm -If $name --path $env{ID_PATH}"
=A0ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D=
"/sbin/mdadm -I $tempnode"
-ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", ACT=
ION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", ACT=
ION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name --path $env{ID_PATH}"
=A0ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", A=
CTION=3D=3D"add", RUN+=3D"/sbin/mdadm -I $tempnode"
=A0
=A0# handle md arrays
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
