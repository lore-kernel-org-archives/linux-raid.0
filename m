From: jimbob palmer <jimbobpalmer@gmail.com>
Subject: Growing a raid array online with different capacity disks
Date: Thu, 10 Mar 2011 13:54:28 +0100
Message-ID: <AANLkTinpcNHZYTnhzv=61e_KAuNHm1j9dp4mQqcKOE_d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I would like to be able to take out a disk from a raid-5 array and add
a higher capacity disk, with the raid array growing in size.

a-la drobo/synology/qnap nas systems.

i.e. 4x1tb disks, take out 1x1tb replace with 1x3tb disk, array grows

Does mdadm support this?

I searched the official faq and debian faq for expand and grow and
didn't find anything.

Thanks a lot.

jbp
