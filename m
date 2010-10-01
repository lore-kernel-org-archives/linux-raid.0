From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Fri, 01 Oct 2010 11:59:43 +0200
Message-ID: <4CA5B10F.2010109@xunil.at>
References: <356617.98037.qm@web51306.mail.re2.yahoo.com> <4CA45D53.3030801@xunil.at> <4CA5A31D.2030306@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA5A31D.2030306@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 01.10.2010 11:00, schrieb Stefan G. Weichinger:

> update: the transported server simply booted ... hmm.
> All the raids valid, nothing suspicious.
> 
> I took the opportunity and upgraded the kernel now. Before I decide how
> to proceed with that hdd I pull some backup to tape. They didn't swap
> tapes for 3 weeks ... oh my.

The current plan is to wait for the backup to finish, after that I will
mark the suspicious sdb-partitions as failed and let the raid rebuild
onto the spare.

After having run the sync_action repair stuff I think I can trust all
the hdds. I issue a "smartctl -t long" now in advance ...

pls correct me if needed ...

Stefan
