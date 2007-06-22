From: Neil Brown <neilb@suse.de>
Subject: Re: Degraded array on every reboot
Date: Sat, 23 Jun 2007 08:49:37 +1000
Message-ID: <18044.20993.729540.359384@notabene.brown>
References: <4755.10.3.3.3.1182516663.squirrel@swilver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Hendrikx on Friday June 22
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 22, hjohn@xs4all.nl wrote:
> 
> I'm considering simply wiping /dev/hde completely so there's no trace of
> the superblock and then re-adding it correctly, but perhaps there's a less
> drastic way to do it.
> 
> Any insights would be appreciated :)

mdadm --zero-superblock /dev/hde

should fix this for you.

NeilBrown
