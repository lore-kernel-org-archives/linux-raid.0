From: Borg Onion <borg.onion@gmail.com>
Subject: RAID1 round robin read support in md?
Date: Sun, 4 Dec 2011 15:31:30 -0800
Message-ID: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Is it possible to implement round-robin read support for raid1.c in
md?  I sure would appreciate the extra speed given my RAID1x3SSD
setup.  A possible algorithm might go like this:

1) Given the RAID1 drives are enumerated 0,1,2
2) For each read request, call an atomic increment
3) mod the returned value with # of drives (3)
4) Use the modulus result as the drive # to read from for this operation

Part of implementation might look like this:

uint32_t get_next_read_drive(uint32_t num_drives)
{
        static uint32_t op_count;

        return __sync_fetch_and_add(&op_count, 1) % num_drives;
}

I'm making the assumption that the md code is multi-threaded.  This
implementation won't work on all platforms, others might have to do
some locking.  The num_drives and drive list enumeration is assumed to
exclude write-mostly devices.  Temporary balancing fairness errors
from the num_drives variable changing value (adding or removing of
drives) should be innocuous given these are just read ops on mirrored
data.

Thoughts?

--
Borg Onion
