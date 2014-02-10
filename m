From: Phil Turmel <philip@turmel.org>
Subject: Re: Reassemble Raid 6
Date: Mon, 10 Feb 2014 18:02:54 -0500
Message-ID: <52F95A9E.2060805@turmel.org>
References: <ema2a9c249-212d-4d96-a89b-b8e4a5d9f827@bigg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ema2a9c249-212d-4d96-a89b-b8e4a5d9f827@bigg>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/10/2014 07:13 PM, Justin Stephenson wrote:
> Hello Phil,
> 
> You are 100% correct. Thanks for your email. I had 2 separate ARRAY
> entries in my mdadm.config file. When I added the spare, I added the new
> information to the config file but did not remove the old entry. Total
> newbie mistake.
> 
> - I commented out all the previous entries in the mdadm.config file (it
> had a devices lists instead of the UUID information)
> 
> - I successfully assembled the array (mdadm --assemble /dev/md0 
> /dev/sdb1 etc...)
> 
> - I  updated the config file using the information from mdadm -Esc
> partitions | grep UUID and deleted the old entries.
> 
> - I uncommented the fstab entry for the array and rebooted.
> 
> 
> Everything is working perfectly now.
> 
> 
> I remember reading somewhere that mdadm can run without the config file
> by using the RAID uuid and the information in the superblocks. Would
> this be more reliable?
> 
> Thanks Again

You're welcome.

I suggest you trim the mdadm.conf file even further--I only specify name
and uuid, so device changes don't interfere with assembly.  Like so
(slightly edited):

MAILFROM mdadm@example.com
MAILADDR philip@example.com

DEVICE /dev/sd[a-z][1-9]

# Mirrored Boot partitions
ARRAY /dev/md1 UUID=75c011c6:caeb06ea:ec7e3370:aa4f3320

# Far mirror (Raid10) core operations
ARRAY /dev/md2 UUID=6b4858da:f24e2567:34e73fe5:b8f2c118

# Bulk redundant (Raid6) storage
ARRAY /dev/md3 UUID=04f3706c:79a3cd73:8a558eee:93ec1879


HTH,

Phil

ps. Don't forget to update your initramfs after any changes to mdadm.conf!

