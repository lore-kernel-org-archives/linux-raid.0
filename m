From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH][2.5] new list macros for md (7 occ)
Date: Thu, 13 Jun 2002 13:47:56 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15624.5612.286223.593221@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0206090837000.26112-100000@hawkeye.luckynet.adm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lightweight patch manager on Sunday June 9
To: Lightweight patch manager <patch@luckynet.dynu.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 9, patch@luckynet.dynu.com wrote:
> This uses the new list macros (list_move*, list_del_init) for the multiple 
> devices driver

Thanks.  I have all of the (the md ones, not the lvm ones) in a patch
that fixes assorted other list.h related uglinesses in the code.  I
will be sending it to Linus shortly.

NeilBrown
