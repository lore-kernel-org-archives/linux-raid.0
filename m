From: David Greaves <david@dgreaves.com>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 18:29:53 +0100
Message-ID: <48FE1191.3030302@dgreaves.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com> <gdkn4n$u6p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gdkn4n$u6p$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> David Greaves <david@dgreaves.com> wrote:
>> The main issue is that the drive being replaced almost certainly has a bad
>> block.
> 
> Then, the replacement is not pro-active ;)
> 
>> This block could be recovered from the raid5 set but won't be.
> 
> This is what 'check' and 'repair' operations
> (/sys/block/md*/md/sync_action) can be used for.

Well, yes and no.

If I have a bad block then I could use the remaining disks to calculate data to
overwrite it. So yes.

However the overwrite may fail. So no.

If I have an md managed mirror then the overwrite will write to the new disk and
the old one. I don't care if the old one fails.


David



-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
