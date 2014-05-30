From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: [PATCH] Do not set default 'before.layout' when reshaping from
 RAID4 to RAID4
Date: Fri, 30 May 2014 14:38:09 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F07918CE9@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Commit fdcad551e9a54c4aa8c4b63160b76e2c539a0441
brings some changes to reshape process.
Setting 'before.layout' when reshaping from RAID4 to another RAID4 is
not really necessary.
If reshape is restarted 'before.layout' will be compared with
'info->array.layout' in reshape_array(). Changes brought by mentioned
commit will cause this comparation return as false, becouse 'array.layo=
ut'
is always set to 'ALGORITHM_PARITY_N' in analyse_change() for RAID4, so
reshape will not be continued after reboot/stop.
This patch reverts unnecessary changes.

Signed-off-by: Pawel Baldysiak pawel.baldysiak@intel.com
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

---
Grow.c | 1 -
1 file changed, 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 487111e..9dc157a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1338,7 +1338,6 @@ char *analyse_change(char *devname, struct mdinfo=
 *info, struct reshape *re)

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 switch (re->level) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 case 4:
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re->bef=
ore.layout =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re->=
after.layout =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 brea=
k;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 case 5:
--=20
1.9.0
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
