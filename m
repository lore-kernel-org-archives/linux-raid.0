From: Martin Wilck <mwilck@arcor.de>
Subject: ddf: remove failed devices that are no longer in use ?!?
Date: Fri, 26 Jul 2013 23:06:01 +0200
Message-ID: <51F2E4B9.1020505@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

here is another question. 2 years ago you committed c7079c84 "ddf:
remove failed devices that are no longer in use", with the reasoning "it
isn't clear what (a phys disk record for every physically attached
device) means in the case of soft raid in a general purpose Linux computer".

I am not sure if this was correct. A common use case for DDF is an
actual BIOS fake RAID, possibly dual-boot with a vendor soft-RAID driver
under Windows. Such other driver might be highly confused by mdadm
auto-removing devices. Not even "missing" devices need to be removed
from the meta data in DDF; they can be simply marked "missing".

May I ask you to reconsider this, and possibly revert c7079c84?
Martin
