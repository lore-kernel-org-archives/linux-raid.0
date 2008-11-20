From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 09:33:15 -0600
Message-ID: <cccedfc60811200733n4fee95degd3bb60ad9dbfe700@mail.gmail.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>
	 <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>
	 <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com>
	 <d5fe39840811192328r6ddf6840y6f86683401bdf533@mail.gmail.com>
	 <c268e4660811200724x5a6a1fffueb2741ccc20006b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660811200724x5a6a1fffueb2741ccc20006b1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why not consider something like drbd or even something like this:

use AoE or iSCSI or NBD or *whatever* that exports a block device over
the network, and use *that* device in a bitmap-backed raid1.

(thus, your raid1 consists of /dev/sdX and /dev/etherd/e0.5 )


-- 
Jon
