From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata badness
Date: Mon, 04 Oct 2004 12:30:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41617AB2.4030702@pobox.com>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu> <Pine.LNX.4.58.0410040953160.26615@web1.mmaero.com> <Pine.LNX.4.60-041.0410041132070.9105@unix43.andrew.cmu.edu> <4161750A.6060200@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4161750A.6060200@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: William Knop <wknop@andrew.cmu.edu>, Jon Lewis <jlewis@lewis.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Mark Lord wrote:
> I have used Maxtor "SATA" drives that require
> the O/S to do a "SET FEATURES :: UDMA_MODE" command
> on them before they will operate reliably.
> This despite the SATA spec stating clearly that
> such a command should/will have no effect.
> 
> I suppose libata does this already, but just in case not..
> Something simple to check up on.

libata always issues SET FEATURES - XFER MODE.

	Jeff


