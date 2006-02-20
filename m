From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid1 with 1.2 superblock never marked healthy?
Date: Mon, 20 Feb 2006 07:48:01 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0602200741570.29156@filesrv1.baby-dragons.com>
References: <priv$1140364975.koan@shadow.banki.hu> <17400.61822.230666.23651@cse.unsw.edu.au>
 <privx$1140425087.koan@lk8rp.mail.xeon.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <privx$1140425087.koan@lk8rp.mail.xeon.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil & All ,

On Mon, 20 Feb 2006, Janos Farkas wrote:
> On 2006-02-20 at 09:30:22, Neil Brown wrote:
>> If you use an 'internal' bitmap (which is mirrored across all drives
>> much like the superblock) then you don't need to specify a file name.
>> However if you want the bitmap on a separate file, you have to have
>> that name 'hard coded' in mdadm.conf (or similar).
>
> I was under the impression that mdadm.conf is not extended for this :)
> That would be a nice place compared to /etc/rc.d/whatever..
>
> I was considering using external bitmap only because I've been bitten a
> few times with journaling filesystems vs. cheap hard disks.  I'm not
> sure if a few hard disks are a significant sample, but some of them
> started developing bad sectors where the journal is stored.  I hoped
> that having an external bitmap would reduce the wear on the mirrored
> parts.  This way, if the bitmap (even on the same hard disk) is getting
> flawed, probably both of the whole mirrors are intact enough for a last
> (additional) backup.
...snip...
 	How hard would it be for mdadm & md to allow use of both internal
 	and external bitmaps ?  And then mdadm be extended to do a compare
 	of an external against a internal when the opertaor askes to do
 	so .  Soes this sound reasonable ?  Thoughts ?
 	This is probably an edge case I guess .  But it might save
 	someones bacon if this functionality was available .
 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
|  http://www.asteriskhelpdesk.com/cgi-bin/astlance/r.cgi?babydr   |
+------------------------------------------------------------------+
