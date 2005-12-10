From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sat, 10 Dec 2005 17:59:45 +1100
Message-ID: <17306.31969.240202.416327@cse.unsw.edu.au>
References: <20051128102824.14498.patches@notabene>
	<1051127234104.14937@suse.de>
	<ee0ae26a0512092241v3ee5e445r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yanggun on Saturday December 10
Sender: linux-raid-owner@vger.kernel.org
To: Yanggun <yang.geum.seok@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday December 10, yang.geum.seok@gmail.com wrote:
> Hi Brown.
> 
> I have raid arrays, raid1 called md0. Basically they run fine, but
> something is switching md0 readonly during write to disk(cp, mv);
> 
> Is changed by that RAID readonly in what case? let me know, describe 
> number of case?
> 
> I am very anxious  about it very. Please, can you inform to me?  Does
> this patch solve it? Can not you do to do not become by readonly?

You will need to give more details about what is happening.  Lots more.

What makes you say the array is 'read-only'  - what are the messages
     you get - exactly?
What filesystem are you using?
What messages are there in the kernel log ('dmesg' might show these)?
What does 'cat /proc/mdstat' show?

NeilBrown
