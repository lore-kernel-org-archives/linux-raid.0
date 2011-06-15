From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH RESEND 0/5] md/raid10 changes
Date: Wed, 15 Jun 2011 13:09:54 +1000
Message-ID: <20110615130954.3e58a12c@notabene.brown>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 11:01:59 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Hello Neil,
> 
> This is a resend of my previous raid10 patches. Some of them are revised
> according to your comments and some of them are not reviewed at all.
> Please take a look.
> 
> Thanks.
> 
> 
> Namhyung Kim (5):
>   md/raid10: optimize read_balance() for 'far offset' arrays
>   md/raid10: get rid of duplicated conditional expression
>   md/raid10: factor out common bio handling code
>   md/raid10: share pages between read and write bio's during recovery
>   md/raid10: spread read for subordinate r10bios during recovery
> 

Thanks.
 I've reject the first and last as explained separately but the others look
 good and I have added them to my tree.  They will probably be submitted in
 the next merge window.

Thanks,
NeilBrown

