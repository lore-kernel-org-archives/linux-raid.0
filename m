From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] Quiet down automated tool checking noise
Date: Wed, 24 Apr 2013 23:45:16 +0200
Message-ID: <wrfjip3bk3gz.fsf@redhat.com>
References: <1366815616-28045-1-git-send-email-Jes.Sorensen@redhat.com>
	<20130425071610.013a58d3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130425071610.013a58d3@notabene.brown> (NeilBrown's message of
	"Thu, 25 Apr 2013 07:16:10 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, 24 Apr 2013 17:00:15 +0200 Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Hi,
>> 
>> Had an automated tool checking the help page moan that -a wasn't
>> documented in the --help output, so lets just add that and keep the
>> noise down :)
>
> Should we add 
>    --foreground -F
> too?

Ahh good point, I forgot about it. Want me to respin it or add a patch
on top?

Cheers,
Jes
