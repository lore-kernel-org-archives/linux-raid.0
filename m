From: Luca Berra <bluca@comedia.it>
Subject: Re: SuSE Linux cluster using MC/ServiceGuard --- shared storage
Date: Tue, 21 Sep 2004 08:34:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040921063411.GA23543@percy.comedia.it>
References: <20040920132846.29970.qmail@web61108.mail.yahoo.com> <20040920135549.GA8201@percy.comedia.it> <20040920183318.GP3592@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040920183318.GP3592@marowsky-bree.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 20, 2004 at 08:33:18PM +0200, Lars Marowsky-Bree wrote:
>On 2004-09-20T15:55:51,
>   Luca Berra <bluca@comedia.it> said:
>
>> >Do I still need to use the Driver Patch for EVA
>> >Controller Failover? 
>> i believe using the qlogic driver failover is a viable solutio,
>
>The DM multipath in 2.6 should handle the EVA just fine.

you mean multipath-tools (http://christophe.varoqui.free.fr/multipath.html)?
i suppose so, using the "group_by_tur" spreading policy. fortunately i
don't have any spare EVA to test, plenty of XP tough :)

>The qlogic internal failover is being depreciated and AFAIK isn't
>included in 2.6 mainline even...

excuse me, are you shipping (or at least supporting) a 2.6 kernel on
your SLES 8.0 product?

>> another is purchasing securepath from HP. but i believe there were
>> issues using securepath and lvm together.
>
>Proprietary multipathing solutions are a thing of the past on Linux, one
>hopes.
i hope so, but for this statement to become true we need some other
vendor to ship a 2.6 based 'enterprise level' distribution with proper
device-mapper implementation, and application vendors (that includes
HP and IBM) to adapt.
Anyway, i do not really believe securepath to be a viable solution(*), i
was enumerating possibilities.

(*) and hp suggests using qlogic 7.00.3 driver with internal failover
for use with their Serviceguard product.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
