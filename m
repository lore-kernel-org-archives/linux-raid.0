From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Questions regarding readonly/readwrite semantics
Date: Thu, 24 Mar 2005 09:25:30 +1100
Message-ID: <16961.60634.327187.954925@cse.unsw.edu.au>
References: <d1q1b3$5j0$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Mario Holbe on Tuesday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 22, Mario.Holbe@TU-Ilmenau.DE wrote:
> Hello,
> 
> in the beginning I had just one simple question :) ...
> Is there any way to start RAIDs in readonly mode while autodetection
> on system boot?

No.
The read-only mode has not been well thought out in md, and I have not
yet put any effort into fixing it.  I might one day, but it is not a
high priority.

The only way you will find answers to your "why does it fail like
this" questions is to hunt through the source code.

NeilBrown
