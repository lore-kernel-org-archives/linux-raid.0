From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: 3-way mirror to RAID-6
Date: Mon, 25 Dec 2017 20:36:59 +0100
Message-ID: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi to all
I have a server with a 3way mirror.
As I have to increase the total available space, one solution would be to
replace all disks with bigger ones, but this is expensive.

Another solution would be to add just one disk and then reshape from
RAID-1 to RAID-6

Do you have any guide on how to do this reshape on a running array ?
Thank you.
