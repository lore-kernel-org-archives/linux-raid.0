From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 12:23:17 +0200
Message-ID: <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170423101639.GA4471@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/23/2017 12:16 PM, Andreas Klauer wrote:
> On Sun, Apr 23, 2017 at 11:47:34AM +0200, Patrik Dahlström wrote:
>> Is there any help you can offer?
> 
> Is there any mdadm --examine output?
At this point, it is incorrect. I've lost the output from the working
raid too, unless it's located in any log in /var/log/.
I have /etc/mdadm/mdadm.conf, but don't know if it's updated.

> 
> What was on the array? Regular filesystem, unencrypted, or LVM, LUKS, ...?
Regular filesystem, unencrypted ext4.

> 
> If it's LUKS encrypted and you had RAID metadata at the end, yet 
> mdadm --create'd new metadata at the start, that would likely have 
> damaged your LUKS header beyond repair (and regular filesystems 
> don't like it, either).
No file system encryption.

> 
> If it's unencrypted data, as a last resort you can always go and find 
> the header of a large file of known type... for example if you find 
> a megapixel JPEG image and the first 512K of it are part of that then 
> your chunksize would be 512K and then you can go looking for the 
> next chunk on the other disks... and that should give you some notion 
> of the RAID layout and offset.
That's not a bad idea. Will hopefully narrow down my unknown variables.

> 
> Regards
> Andreas Klauer
> 
