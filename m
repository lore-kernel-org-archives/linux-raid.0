From: Mark Lord <lkml@rtr.ca>
Subject: Re: libata badness
Date: Mon, 04 Oct 2004 12:06:34 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4161750A.6060200@rtr.ca>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu> <Pine.LNX.4.58.0410040953160.26615@web1.mmaero.com> <Pine.LNX.4.60-041.0410041132070.9105@unix43.andrew.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.60-041.0410041132070.9105@unix43.andrew.cmu.edu>
To: William Knop <wknop@andrew.cmu.edu>
Cc: Jon Lewis <jlewis@lewis.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

I have used Maxtor "SATA" drives that require
the O/S to do a "SET FEATURES :: UDMA_MODE" command
on them before they will operate reliably.
This despite the SATA spec stating clearly that
such a command should/will have no effect.

I suppose libata does this already, but just in case not..
Something simple to check up on.
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")

William Knop wrote:
>
> Ah, well all of them are Maxtor drives... One 6y250m0 and three 7y250m0 
> drives. I'm using powermax on them right now. They all passed the quick 
> test, and the full test results are forthcoming.
