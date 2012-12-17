From: Phil Turmel <philip@turmel.org>
Subject: Re: strange partition table and slow speeds
Date: Mon, 17 Dec 2012 12:18:42 -0500
Message-ID: <50CF53F2.30404@turmel.org>
References: <CA+Z7oPgjAsj3f571ocN9zS2sGjgdMsK97_H6qR20o1GPUJYVKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Z7oPgjAsj3f571ocN9zS2sGjgdMsK97_H6qR20o1GPUJYVKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Pientka <alex.pientka@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Alex,

On 12/17/2012 09:17 AM, Alex Pientka wrote:

[trim /]
> 
> /dev/md0:
>         Version : 1.1

                   ^^^^^
You've deliberately chosen a metadata version that places the superblock
at sector 0 of the given device.  If that is a whole disk, it overwrites
the partition table.  The default metadata is v1.2 (which places the
superblock at offset 4k) for this very reason.

HTH,

Phil
