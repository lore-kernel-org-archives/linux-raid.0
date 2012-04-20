From: daobang wang <wangdb1981@gmail.com>
Subject: about stripe cache in raid5.c
Date: Fri, 20 Apr 2012 12:49:19 +0800
Message-ID: <CACwgYDNHJWGjf3J4jCvo9ZsoUV6-fsUUOOmbKK4mZhAS-hTp_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

    We can see the stripe cache in raid5.c, which is defined as follow,
#define NR_STRIPES              256
It could improve the performance for raid, which value is the best?
which things should be considered when i change this value?

    Thank you very much!

Best Regards,
Daobang Wang.
