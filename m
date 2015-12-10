From: "P. Remek" <p.remek1@googlemail.com>
Subject: start dm-multipath before mdadm raid
Date: Thu, 10 Dec 2015 16:29:47 +0100
Message-ID: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am trying to create mdadm raid on top of dm-multipath devices.
Everything works but after reboot the mdadm array is assembled from
the original (not multipath devices) devices and the multipath devices
are not created at all.

Aparently it is because the mdadm software raid is started before the
dm-multipath creates the multipathed devices. Is there a way how to
make the dm-multipath start before the mdadm is started?

Regards,
Remek
