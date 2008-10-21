From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 15:57:43 +0200
Message-ID: <gdkn4n$u6p$1@ger.gmane.org>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com>
 <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
> The main issue is that the drive being replaced almost certainly has a bad
> block.

Then, the replacement is not pro-active ;)

> This block could be recovered from the raid5 set but won't be.

This is what 'check' and 'repair' operations
(/sys/block/md*/md/sync_action) can be used for.


regards
   Mario
-- 
When Bruce Schneier uses double ROT13 encryption, the ciphertext is totally
unbreakable.

