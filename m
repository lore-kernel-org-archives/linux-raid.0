From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: RAID1 assembly requires manual "mdadm --run"
Date: Thu, 7 Jul 2005 08:18:26 +0200
Message-ID: <62b0912f05070623185b90e732@mail.gmail.com>
References: <200506261621.01799.mlaks@verizon.net>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506261621.01799.mlaks@verizon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:
> However I think that raids should boot as long as they are intact, as a matter
> of policy. Otherwise we lose our  ability to rely upon them for remote
> servers...

It does seem wrong that a RAID 5 starts OK with a disk missing, but a
RAID 1 fails.

Perhaps MD is unable to tell which disk in the RAID 1 is the freshest
and therefore refuses to assemble any RAID 1's with disks missing?
