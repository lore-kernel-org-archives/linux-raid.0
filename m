From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 6 reshape failed (false message about critical section)
Date: Wed, 5 Sep 2007 13:36:17 +0100
Message-ID: <18142.41665.719883.549678@notabene.brown>
References: <515CA0AD-2BAF-437A-8A41-260F7A27BADB@harekrishna.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anton Voloshin on Wednesday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Anton Voloshin <ashutosh@harekrishna.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 5, ashutosh@harekrishna.ru wrote:
> 
> Please advise me how should I proceed to resolve this situation and  
> save my data if possible (yes, unfortunately I was going to make  
> backups in a week but did not had them yet - too bad for me :-( ).

Hi.
 thanks for the detailed report.

I can see what the problem is.  It will take a little while to figure
out what the "correct" fix it, but a quick fix to get you out of
trouble would be to remove the lines:

		if (info->array.utime > __le64_to_cpu(bsb.mtime) + 3600 ||
		    info->array.utime < __le64_to_cpu(bsb.mtime))
			continue; /* time stamp is too bad */

from Grow.c in mdadm (around line 925).  This change is definitely
safe for your case, and should get the array assembled and the reshape
restarted.  Please let me know how it goes.

NeilBrown
