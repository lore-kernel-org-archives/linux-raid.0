From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Sat, 01 Nov 2014 23:22:04 -0400
Message-ID: <5455A35C.2060000@turmel.org>
References: <loom.20141031T141939-473@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20141031T141939-473@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/31/2014 09:34 AM, Vince wrote:
> Hi,
>
> got a drive failure (bad block) during Raid5 grow (4x3TB -> 5x3TB).
> Well... i don't have a backup file :/
> Mdadm shows 1 drive as removed.
>
> All 4 'good' drives are in the same reshape pos'n.
>
> Any idea how to finish the reshape process? Or get the array back?

mdadm --stop /dev/md0
mdadm --assemble --force --verbose /dev/md0 /dev/sd[bcdf]

If that doesn't work, please show us the output.

You haven't (yet) lost your array.  It's just degraded.  You should 
investigate why the one drive was kicked out of the array instead of 
being rewritten properly (green drives?).  In the meantime, assembly 
with --force should give you access to the data to grab anything 
critically important.

If you share the output of "smartctl -x /dev/sdX" for at least the 
kicked drive, we can offer further advice.

Regards,

Phil
