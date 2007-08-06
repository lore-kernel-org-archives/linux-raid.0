From: Christina Braun <braun@mail.informatik.uni-essen.de>
Subject: question: max TB  of raid-device
Date: Mon, 06 Aug 2007 18:27:13 +0200
Message-ID: <46B74BE1.5010608@mail.informatik.uni-essen.de>
Reply-To: braun@dc.uni-due.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I want to create a mirror for the hw-raid5-disk (now ca. 2,4- growing up
to ca. 12TB) with iscsi and softwareraid over 2 big storage-server.
One server is the initiator, one the iscsi-target-server.
What is the maximum size  that a software-raid-device (1 Part of the
mirror) can be?


OS: debian-etch, 2.6.18-4-amd64, 2 server with hardwareraid  9590SE-16ML
and extra disk for OS.
extra-compiled  parted, gpt-table, lvm2

Thank You very much,
with best regards,
Christina




-- 
**********************************************   /\_/\
* email: braun@dc.uni-due.de                    / 0 0 \
* Christina Braun                              ====v====
* FB. 5, ICB / Informatik                       \  W  /	
* University DE                                 |    |
* Schuetzenbahn 70  tel.: + 49    201 183-3929  / ___ \    /
* D-45127 Essen     fax.: + 49    201 183-2419 / /   \ \  |
**********************************************(((-----)))-'

