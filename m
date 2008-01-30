From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 05:44:49 -0600
Message-ID: <47A06331.5050709@pobox.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F4CFC.5060305@pobox.com> <47A05971.1020507@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A05971.1020507@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:

> Moshe Yudkowsky wrote:
>> I expect it's because I used 1.2 superblocks (why
>> not use the latest, I said, foolishly...) and therefore the RAID10 --
> 
> Aha - an 'in the wild' example of why we should deprecate '0.9 1.0 1.1, 1.2' and
> rename the superblocks to data-version + on-disk-location :)

Even if renamed, I'd still need a Clue as to why to prefer one scheme 
over the other. For example, I've now learned that if I want to set up a 
RAID1 /boot, it must actually be 1.2 or grub won't be able to read it. 
(I would therefore argue that if the new version ever becomes default, 
then the default sub-version ought to be 1.2.)

As to the wiki: I am not certain I found the Wiki you're referring to; I 
did find others, and none had the ringing clarity of Peter's definitive 
"RAID10 won't work for /boot."

The process I'm going through -- cloning an old amd-k7 server into a new 
amd64 server -- is something I will document, and this particular grub 
issue is one of the things I intend to mention. So, where is this Wiki 
of which you speak?

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "A kind word will go a long way, but a kind word and
   a gun will go even further."
    					-- Al Capone
