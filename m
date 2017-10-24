From: Roman Mamedov <rm@romanrm.net>
Subject: Re: upgrading LSI SAS9211-8i fw IR->IT
Date: Tue, 24 Oct 2017 22:59:26 +0500
Message-ID: <20171024225926.48873932@natsu>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <20171024171457.563fbb2a@natsu>
 <fd16035d-adaa-ddc5-1726-7b3873871853@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd16035d-adaa-ddc5-1726-7b3873871853@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 25 Oct 2017 00:04:37 +1100
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> I want to avoid the risk of the IR fw writing any metadata to the disks which already
> hold a software RAID.
> 
> Is it not the case that the IR fw may mess with the disks (I read a comment suggesting it might)?

I believe when HW RAID controllers do that, they set up HPA to reserve a small
area at the end, and write the metadata there. But just checked, there is no
HPA on any of the 3 disks that I have connected.


$ sudo hdparm -N /dev/sdi

/dev/sdi:
 max sectors   = 3907029168/3907029168, HPA is disabled

$ sudo hdparm -N /dev/sdh

/dev/sdh:
 max sectors   = 3907029168/3907029168, HPA is disabled

$ sudo hdparm -N /dev/sdg

/dev/sdg:
 max sectors   = 3907029168/3907029168, HPA is disabled


You can test by connecting some disk with data you don't care about, and
checking if its contents get modified (especially at the end), or if it gets
HPA enabled.

-- 
With respect,
Roman
