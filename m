From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: remark and RFC
Date: Thu, 17 Aug 2006 16:11:37 +0200
Message-ID: <ec1tep$rmm$1@sea.gmane.org>
References: <200608160906.k7G96A204753@inv.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@inv.it.uc3m.es> wrote:
> 1) I would like raid request retries to be done with exponential
>    delays, so that we get a chance to overcome network brownouts.

Hmmm, IMHO this should be implemented in nbd/enbd where it belongs to
and errors should be masked within nbd/enbd then. Since (at least) md
has no read-timeouts or something like that (please correct me if I'm
wrong), this should be no big issue.

Typically, storage media communication channels are loss-free, so either
a read is okay or it fails. A storage media usually has no retry-on-
timeout semantics, so upper layers are with high probability not aware
of such a thing. This is the same with RAID as well as with filesystems,
so if you run an ext2 or something like that on top of your enbd you
should suffer from the same problems: if a read fails, the filesystem
goes dead, gets remounted read-only or follows whatever error-strategy
you have it configured for.


regards
   Mario
-- 
() Ascii Ribbon Campaign
/\ Support plain text e-mail

