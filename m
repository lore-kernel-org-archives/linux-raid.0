From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: RAID1 and data safety?
Date: Wed, 16 Mar 2005 10:13:59 +0100
Message-ID: <62b0912f05031601131b8daf4a@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just wondering;

Is there any way to tell MD to do verify-on-write and
read-from-all-disks on a RAID1 array?

I was thinking of setting up a couple of RAID1s with maximum data safety.
I'd like to verify after each write to a disk plus I'd like to read
from all disks and perform data comparison whenever something is read.
 I'd then run a RAID0 over the RAID1 arrays, to regain some of the
speed lost from all of the excessive checking.

Just wondering if it could be done :-).

Apologies if the answer is in the docs.
