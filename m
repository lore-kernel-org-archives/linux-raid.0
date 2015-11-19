From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID 6 Reshape Woes
Date: Wed, 18 Nov 2015 23:23:02 -0500
Message-ID: <564D4EA6.7020508@websitemanagers.com.au>
References: <41BC47FD-C02B-4DDA-BF1C-75032831AA29@abitofthisabitofthat.com>
 <564D249C.308@turmel.org>
 <6D622406-5CAB-4096-987B-AA45AF9F448A@abitofthisabitofthat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6D622406-5CAB-4096-987B-AA45AF9F448A@abitofthisabitofthat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Parada <cisco@abitofthisabitofthat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 18/11/2015 21:45, Francisco Parada wrote:
>
> What do you guys think?
>> New enclosures & controllers so you can ditch the port multipliers?
> Yeah, I'm thinking of just building a 4U and using an LSI RAID controller I have laying around, use it as JBOD letting mdadm do the lifting, and stop with these damn cases already. I was just trying to do the best with what I had, but going this Port Multiplier route is what's getting me into this mess. I have a couple of SunFire x2270 1U systems fully spec'ed out that I wanted to take advantage of, and by using these external enclosures, I was getting around the 4 hard drive bay limitation. I guess I'll build something that's cheap just to mount the drives and share via Samba and NFS onto the SunFire systems, then do the heavy CPU lifting from there instead.

I've used nbd before to export a drive from one machine to use as a 
RAID1 member, added with a local block device (mdadm) and that worked 
really reliably for me (the remote nbd was also set as write-mostly).

Since then I've also used DRBD to manage both parts of that.

However, in your case, I think there is a more modern version of nbd 
which basically exports a block device as a SATA device over the 
network. Could you utilise your "couple" of 4 bay 1RU servers, and most 
of them use a single drive (or partition from a couple of drives in 
RAID1), and export the other partition (95% disk space) to the one 
"server" which will then combine them all with mdadm RAID6 or whatever 
is needed ?

One problem you have here is that you will lose too many "members" 
whenever one of your machines reboots.

Other options come to mind, but they certainly become more complex, and 
further away from where you are now.

Not sure if any of the above is useful, or if anyone else can comment on 
how well those options work, especially the SATA export for use with 
mdadm would be interesting (better if each server was exporting only 1 
disk, then you can lose a machine (or disk) without data loss.

Regards,
Adam
