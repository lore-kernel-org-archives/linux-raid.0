From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: FW: [PATCH 2/2] Grow: Do not fork via systemd if freeze_reshape is
 set
Date: Fri, 30 May 2014 14:40:11 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F07918D3F@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Mdadm should not run 'grow-continue' unit file for container if
'--freeze-reshape' argument is passed. Otherwise it will be ignored,
and reshape will start anyway.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
Grow.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 158a709..487111e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3472,7 +3472,7 @@ int reshape_container(char *container, char *devn=
ame,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0*/
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ping_monitor(container);

-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!forked && !check_env("MDA=
DM_NO_SYSTEMCTL"))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!forked && !freeze_reshape &&=
 !check_env("MDADM_NO_SYSTEMCTL"))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 if (continue_via_systemd(container))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retu=
rn 0;

--=20
1.9.0
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
