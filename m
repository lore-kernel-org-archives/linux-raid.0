From: Marcel <marcelb@wanadoo.nl>
Subject: Re: Floating Spare
Date: Mon, 08 Apr 2002 21:05:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CB1E9F4.6070101@wanadoo.nl>
References: <20020408184316Z313731-22651+2106@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: SoulBlazer <soul@lamp-post.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

SoulBlazer wrote:
> Can you share 2 or 3 'spare-disks' between multiple raid sets?
> 
> Eg. I have a 22 disk array chopped into multiple 4 disk raid-5 volumes, this 
> leaves me with 2 disks left over..  Can I assign these two drives as floating 
> spares incase of failure.. this will obviously be a 'first come first serve' 
> scenario for raid failure.. but its better then not using them.

I'm sure you could script something to that effect based on the current 
RAID tools and their options/output...

If there's nothing like it already included (I haven't checked - and no 
in-depth knowledge of raid tools either, so forgive any stupid remarks) 
I could imagine a cron job checking the logs for disk failures and 
hot-adding the "new" disk (one of the spares, if available).

Interesting idea!

Marcel

