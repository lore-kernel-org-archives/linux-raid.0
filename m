From: David Greaves <david@dgreaves.com>
Subject: Re: Requesting replace mode for changing a disk
Date: Thu, 14 May 2009 11:44:01 +0100
Message-ID: <4A0BF5F1.7040804@dgreaves.com>
References: <20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>	<87zldhvg0v.fsf@frosties.localdomain> <18954.20061.109627.591832@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.20061.109627.591832@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> The one problem with this approach is that if there is a read error on
> /dev/suspect while data is being copied to /dev/new, you lose.
> 
> Hence the requested functionality which I do hope to implement for
> raid456 and raid10 (it adds no value to raid1).
> Maybe by the end of this year... it is on the roadmap.

Neil,
If you have ideas about how this should be accomplished then outlining them may
provide a reasonable starting point for those new to the code; especially  if
there are any steps that you may clearly see that would help others to make a start.

I've posted this request a few times but the md code is sufficiently
overwhelming that I haven't attempted a solution.

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
