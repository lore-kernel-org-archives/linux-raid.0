From: "WEI Yongjun" <yjwei@nanjing-fnst.com>
Subject: [raidtools]Linux device number bug report
Date: Mon, 2 Feb 2004 15:01:25 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01a401c3e95a$60b292b0$3001a8c0@WEIYONGJUN>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: mingo@redhat.com
Cc: linux-raid@vger.rutgers.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have some questions about device number extension.

In Linux kernel 2.6, device number will be extended from 16-bit to 32-b=
it.
All utilities and libraries should make corresponding extension for thi=
s new
feature in kernel 2.6.

I find that "raidtools-1.00.3-7" uses structure dev_t and operates the
device number as 16-bit.
-----------------------------------------------------------------------=
-----
--------------
lsraid.c line 59:

#define MAJORBITS 8
#define MINORBITS 8
#define MAJORS (1 << MAJORBITS)
#define MINORS (1 << MINORBITS)

It defined major device number and minor device number as 8 bit, but no=
w
major device number is 12 bit and minor device is 20 bit.
-----------------------------------------------------------------------=
-----
--------------

Since I didn=A1=AFt find any information about this aspect in homepage =
of this
package, I wonder whether the latest version has completed the device n=
umber
extension? If not, will it be completed in the future? And when?

Looking forward to answering.


Best Regards

--------------------------------------------------
Wei Yongjun
Dept. of Technology and Development
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 16-5, Guanzhou Rd., Nanjing, P.R.China
PHONE: +86+25-6630523-633
=46UJITSU INTERNAL: 79955-651
=46AX: +86+25-3317685
Mail: yjwei@nanjing-fnst.com
--------------------------------------------------

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
