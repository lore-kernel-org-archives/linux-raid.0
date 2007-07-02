From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Mon, 2 Jul 2007 08:50:11 +0200
Message-ID: <200707020850.11361.infomails@tronserver.dyndns.org>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <18056.9918.537787.152462@notabene.brown> <200707020835.18420.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707020835.18420.infomails@tronserver.dyndns.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 02 July 2007 08:35:18 Michael Frotscher wrote:

> Hmm, I'd need to check that after I rebuild the arrays. Maybe the other
> IDE-controller is not in the initrd. 

No, although this sounded like a good idea. The IDE controller is initialized 
before the assembly of the arrays and even including its driver explicitly in 
the initrd results in a initrd of the same size as before, so it had been in 
there all along.
-- 
YT,
Michael
