From: "Christian Pernegger" <pernegger@gmail.com>
Subject: RAID resync after every boot?
Date: Thu, 29 Jun 2006 11:05:20 +0200
Message-ID: <bb145bd20606290205p5f367b5bu8c3051b6fcc4fc51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yesterday evening I initialized a new RAID5, waited for completion and
shut down the machine. Yet when I restarted it this morning it
immediately began with a resync -- it seems that it wants to resync on
every boot ...

This is a new Debian testing installation, array was created with EVMS
and is started with EVMS in the initrd. mdadm is used for monitoring
and maintainance.

Grepping through the init scripts I really could find nothing that
looked like it shut down md arrays -- when and where is that supposed
to happen?

Of course I could use mdadm to stop the array by hand before issuing
shutdown, but I'm sure this has worked out-of-the-box before, and
besides I can't do it for the roo-on-RAID1 I intend on adding.

Thanks,

C.
