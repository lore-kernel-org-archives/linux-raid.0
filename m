From: Krzysztof Oledzki <olel@ans.pl>
Subject: Unable to compile mdadm-2.1 in IA64 enviroment
Date: Sat, 12 Nov 2005 21:14:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511122108140.25410@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2122405479-1131826491=:25410"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2122405479-1131826491=:25410
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

Compilation of mdadm-2.1 fails with following warinings:

bitmap.c: In function `bitmap_fd_read':
bitmap.c:130: warning: int format, different type arg (arg 3)
bitmap.c:171: warning: long long unsigned int format, __u64 arg (arg 3)
bitmap.c: In function `ExamineBitmap':
bitmap.c:265: warning: long long unsigned int format, __u64 arg (arg 2)
bitmap.c:266: warning: long long unsigned int format, __u64 arg (arg 2)
bitmap.c:276: warning: long long unsigned int format, __u64 arg (arg 2)
make: *** [bitmap.o] Error 1

Since -Werror exists in CWFLAGS, each warning ends up as compliation=20
error.

Older version - 1.12.0 can be compiled without any problems.

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2122405479-1131826491=:25410--
