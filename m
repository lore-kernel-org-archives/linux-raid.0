From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUG: Data corruption on Raid5 in Linux 2.6.0
Date: Sun, 28 Dec 2003 16:47:55 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16366.28299.160756.494452@notabene.cse.unsw.edu.au>
References: <20031228000008.B2433@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Brahneborg on Sunday December 28
To: Daniel Brahneborg <daniel.com@wtnord.net>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 28, daniel.com@wtnord.net wrote:
> Hi,
> 
> I have a Raid5 system of four 160GB SATA disks. The drives
> themselves work fine, but when large files (a few hundred
> megs) are written to the raid disks they get corrupted after
> a random amount of data.  The kernel is Linus 2.6.0.
> 
> Any hints you can give me to get this working is highly
> appreciated.

What file system?
Are you using DeviceMapper over the raid5?

If you are using DeviceMapper, can you try without it?

(I don't think there is a proble with DeviceMapper, but it drives
raid5 slightly differently to e.g. direct ext3 and could trigger a bug
in raid5.)

NeilBrown
