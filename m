From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Fri, 01 Oct 2010 23:20:28 +0200
Message-ID: <4CA6509C.5090903@xunil.at>
References: <356617.98037.qm@web51306.mail.re2.yahoo.com> <4CA45D53.3030801@xunil.at> <4CA5A31D.2030306@xunil.at> <4CA5B10F.2010109@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA5B10F.2010109@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 2010-10-01 11:59, schrieb Stefan G. Weichinger:

> The current plan is to wait for the backup to finish, after that I will
> mark the suspicious sdb-partitions as failed and let the raid rebuild
> onto the spare.
> 
> After having run the sync_action repair stuff I think I can trust all
> the hdds. I issue a "smartctl -t long" now in advance ...
> 
> pls correct me if needed ...

Let me add this:
I also like some "yep, go for it, you are doing the right thing" ;-)

Greets, Stefan
