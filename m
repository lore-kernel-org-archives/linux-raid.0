From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Are we forced to use bad blocks list?
Date: Thu, 31 Jul 2014 16:31:28 +0200
Message-ID: <53DA5340.7080507@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear MD developers,
it seems that with mdadm 3.3.1 , if an array has bad blocks disabled 
(e.g. "--update=no-bbl"  was invoked) and we want to add a disk to that 
array, e.g. a spare, that one will be created by mdadm with BBL enabled 
during the --add operation.

There is apparently no "--add --no-bbl" option in mdadm, so the BBL will 
result in being forcibly active for that disk, it seems to me.

It is indeed possible to "--stop" the array and then "--assemble 
--update=no-bbl" so to clear the BBL flag in all disks, but this 
requires stopping the array, which for a production system often is not 
possible, and not justified for just adding a spare.

Can I add a "feature request" to have BBL optional, and/or to default 
BBL presence/absence so that it conforms to the presence/absence of BBLs 
in the other disks of the array which is already running?

The same problem probably happens when mdadm monitor daemon moves spares 
among the spare-group: it should probably understand if the receiving 
array is configured for BBL or not, and add a spare of the same type.

Thank you
EW
