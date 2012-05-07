From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Feature request for mdadm 3.3
Date: Tue, 8 May 2012 01:25:31 +0200
Message-ID: <CAAOsTSn_mcy-W65zty727b=PCwp31qBgSANmGLzQv3DB2oBxiw@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have one feature request for mdadm 3.3, support for upgrade of
metadata 0.9 to metadata 1.0.

I guess there is a lot of old raid arrays with metadata 0.9 out there,
because raid / lvm  are often used for its expansibility and longevity
and thus I guess many of them evolved from old 0.9 raid arrays. At
least I have a few of them.

Upgrade to 1.0 is now of course very needed because of two new very
important features in latest kernel versions requiring 1.x,
hot-replace and badblock log.

Manual upgrade by recreating array is pretty risky on important data,
so support for this feature in mdadm would be very appreciated. What
do you think guys, will it be useful feature?

Thanks.

Patrik Horn=EDk
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
