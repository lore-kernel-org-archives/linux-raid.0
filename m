From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm and superblock format > 1
Date: Tue, 7 Aug 2007 20:47:03 +1000
Message-ID: <18104.19879.613392.675207@notabene.brown>
References: <46B8479C.5010600@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michal Soltys on Tuesday August 7
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <nozo@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 7, nozo@ziu.info wrote:
> I've noticed, that whenever I use 1.1 or 1.2 superblock format, mdadm 
> will always report version 1, when i.e. mdadm -E --scan is issued.
> 
> Also, in these two cases, mdadm -A --scan won't work, unless proper 
> ARRAY line is present in mdadm.conf (and if metadata is part of the 
> description, it must be either 1.1 or 1.2).

This is fixed in the current git repository.  It will be in the next
release whenever I get around to making one.

This is that patch that fixes it.

http://neil.brown.name/git?p=mdadm;a=commitdiff;h=a17a3de364806681fc7c1395364d11061a638ff3

NeilBrown
