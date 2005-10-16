From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH md 000 of 8] Introduction
Date: Sun, 16 Oct 2005 09:57:06 -0600 (MDT)
Message-ID: <Pine.LNX.4.64.0510160953530.11227@filesrv1.baby-dragons.com>
References: <20051014122335.11602.patches@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051014122335.11602.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,  Is it possible to inert in the 'Introduction's for your
 	patches a Min & Max kernel level they will successfully patch
 	against ?  ie: 2.6.12 to 2.6.14-rc4 or some such .
 	That would sure take the angst out of guessing .  Tia ,  JimL

On Fri, 14 Oct 2005, NeilBrown wrote:
> 8 patches for md/raid in 2.6 follow.
>
> The first replaces
>   md-identify-raid-rcu-protected-pointer.patch
> which has some minor issues.
> 2 and 3 fix problems in previous patches identified by some kindly code reviewers.
>
> Thanks,
> NeilBrown
>
>
> [PATCH md 001 of 8] Provide proper rcu_dereference / rcu_assign_pointer annotations in md
> [PATCH md 002 of 8] Fix ref-counting problems with kobjects in md
> [PATCH md 003 of 8] Minor MD fixes
> [PATCH md 004 of 8] Change raid5 sysfs attribute to not create a new directory.
> [PATCH md 005 of 8] Improvements to raid5 handling of read errors
> [PATCH md 006 of 8] Convert 'faulty' and 'in_sync' fields to bits in 'flags' field.
> [PATCH md 007 of 8] Make md on-disk bitmaps not host-endian
> [PATCH md 008 of 8] Support BIO_RW_BARRIER for md/raid1.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
