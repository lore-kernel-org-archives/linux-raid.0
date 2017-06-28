From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Disk Monitoring
Date: Wed, 28 Jun 2017 12:25:55 +0200
Message-ID: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all
I always used hardwre raid but with my next server I would like to use mdadm.

Some questions:

1) all raid controllers have proactive monitoring features, like
patrol read, consistency check and (more or less) some SMART
integration.
Any counterpart in mdadm?

2) thanks to this features, raid controller are usually able to detect
disk issues before they cause data-loss. what about mdadm ?

How and when do you replace disks ? Based on which params? Do you
always wait for a total failure before replacing the disk?

Is mdadm able to notify some possible bad-things before they happens ?

Many times in the past our raid controllers forced a bad sector
reallocation during proactive tasks like patrol read. This saved me
many times before. I've tried to not replace a disks when this
reallocation was made (it was a test server) and after some weeks the
disk failed totally.
