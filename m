From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid 6 recovery
Date: Thu, 2 Nov 2017 23:47:33 +0000
Message-ID: <59FBAE95.6010206@youngman.org.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
 <59F8BCE9.1070607@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59F8BCE9.1070607@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Crisp <jcrisp@safeandsoundit.co.uk>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 31/10/17 18:11, Wols Lists wrote:
> It's possible - I wouldn't know - that the existence of the MBR stops
> mdadm looking for a superblock that applies to the whole drive, which
> could explain why those drives have disappeared.

Just been digging in the code - function check_raid - I think if you
pass a drive to mdadm it checks the drive for a superblock, and doesn't
look for whether a partition table exists. So I think that's that
explanation blown out the water ... :-(

Cheers,
Wol
