From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Thu, 23 Feb 2012 00:16:40 +0100
Message-ID: <4F457758.8060807@redhat.com>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com> <20120223090412.2b14fb7f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120223090412.2b14fb7f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/22/12 23:04, NeilBrown wrote:
> On Wed, 22 Feb 2012 17:59:59 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> I have seen this come up on the list a couple of times, and also had
>> bugs filed over it, since this used to 'work'. Making the printed
>> error message a little more explicit should hopefully make it clearer
>> why this is being rejected.
>>
>> Thoughts?
> 
> While I'm always happy to make the error messages more helpful, I don't think
> this one does :-(
> 
> The reason for the change was that people seemed to often use "--add" when
> what they really wanted was "--re-add".
> --add will try --re-add first, but it if that doesn't succeed it would do the
> plain add and destroy the metadata.
> 
> So I introduced the requirement that if you want to destroy metadata, you
> need to do it explicitly (and I know that won't stop people, but hopefully it
> will slow them down).
> 
> Also, this is not at all specific to raid1 - it applies equally to
> raid4/5/6/10.

Yeah I realize it is not ideal. The reason I tried to make it more
descriptive is that I have been hit with a couple of bug reports where
users suddenly found that things no longer behave like they used to and
just file a bug against it, because the error message doesn't spell it
out in flashing neon. I was trying to improve the message somehow, but I
am sure my attempt wasn't perfect.

The goal was to try and reduce the number of bug reports over this by
making it more obvious/explicit, so if you have a suggestion for how to
do so in a better way, I am all game.

Cheers,
Jes


