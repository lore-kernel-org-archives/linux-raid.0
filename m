From: CoolCold <coolthecold@gmail.com>
Subject: [PATCH][Trivial] mdadm man page: fix typo
Date: Thu, 12 Apr 2012 06:11:19 +0400
Message-ID: <CAGqmV7ovw0fW2HE0s69Ci7Y15YWGpnvESfW=rt=rEbp0kWPp_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

manpage for mdadm(8) contains typo - missing "d" at the end of "describe" word.

Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
---
 mdadm.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 4f06a88..bddecd9 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1166,7 +1166,7 @@ will report failure if these specifiers didn't
find any match.
 .BR \-a ", " \-\-add
 hot-add listed devices.
 If a device appears to have recently been part of the array
-(possibly it failed or was removed) the device is re\-added as describe
+(possibly it failed or was removed) the device is re\-added as described
 in the next point.
 If that fails or the device was never part of the array, the device is
 added as a hot-spare.
--
1.7.2.5
1.7.2.5


-- 
Best regards,
[COOLCOLD-RIPN]
