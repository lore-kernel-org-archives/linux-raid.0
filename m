From: Rik van Riel <riel@redhat.com>
Subject: Re: Was: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Thu, 8 Nov 2007 12:06:25 -0500
Message-ID: <20071108120625.7e0572b1@bree.surriel.com>
References: <1194084522.1353.10.camel@localhost>
	<87fxziju0z.fsf@informatik.uni-tuebingen.de>
	<1194520008.17369.19.camel@localhost>
	<87prykaeh6.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87prykaeh6.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: konstantin.sharlaimov@gmail.com, Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, linux-raid <linux-raid@vger.kernel.org>, "; Ingo Molnar" <mingo@redhat.com>, "; Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

On Thu, 08 Nov 2007 17:28:37 +0100
Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de> wrote:

> Maybe you need more parameter:

Generally a bad idea, unless you can come up with sane defaults (which
do not need tuning 99% of the time) or you can derive these parameters
automatically from the RAID configuration (unlikely with RAID 1?).

Before turning Konstantin's nice and simple code into something complex,
it would be good to see benchmark results show that the complexity is
actually needed.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
