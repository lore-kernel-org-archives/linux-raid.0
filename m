From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 14:38:23 +0200
Message-ID: <4CA3333F.7060108@xunil.at>
References: <4CA300EB.1070909@xunil.at> <4CA32AA3.3090602@msgid.tls.msk.ru> <4CA32F61.3070802@seoss.co.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA32F61.3070802@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 2010-09-29 14:21, schrieb Tim Small:

>> It should be repair, not check - check merely reads stuff, repair tries
>> to fix it.
> 
> No it shouldn't, AFAIK - check will read from all sectors on all drives,
> and will trigger a rewrite on unreadable blocks (which is what the  OP
> has).

I ran a repair on md3 now, currently I do it for md4.

kernel-docs say:

   sync_action
     a text file that can be used to monitor and control the rebuild
     process.  It contains one word which can be one of:
       resync        - redundancy is being recalculated after unclean
                       shutdown or creation
       recover       - a hot spare is being built to replace a
                       failed/missing device
       idle          - nothing is happening
       check         - A full check of redundancy was requested and is
                       happening.  This reads all block and checks
                       them. A repair may also happen for some raid
                       levels.
       repair        - A full check and repair is happening.  This is
                       similar to 'resync', but was requested by the
                       user, and the write-intent bitmap is NOT used to
                       optimise the process.

thanks, Stefan
