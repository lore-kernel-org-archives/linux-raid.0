From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 12:16:39 +0200
Message-ID: <20170423101639.GA4471@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 23, 2017 at 11:47:34AM +0200, Patrik Dahlström wrote:
> Is there any help you can offer?

Is there any mdadm --examine output?

What was on the array? Regular filesystem, unencrypted, or LVM, LUKS, ...?

If it's LUKS encrypted and you had RAID metadata at the end, yet 
mdadm --create'd new metadata at the start, that would likely have 
damaged your LUKS header beyond repair (and regular filesystems 
don't like it, either).

If it's unencrypted data, as a last resort you can always go and find 
the header of a large file of known type... for example if you find 
a megapixel JPEG image and the first 512K of it are part of that then 
your chunksize would be 512K and then you can go looking for the 
next chunk on the other disks... and that should give you some notion 
of the RAID layout and offset.

Regards
Andreas Klauer
