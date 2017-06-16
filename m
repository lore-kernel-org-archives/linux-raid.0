From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Sat, 17 Jun 2017 03:22:02 +0800
Message-ID: <4173d6b5-283f-aac4-c371-f41baf97d648@fnarfbargle.com>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
 <877f0c7gvr.fsf@notabene.neil.brown.name>
 <20170616155204.myffyxp5tuoctcoo@kernel.org>
 <40a41d94-b930-e402-9ce4-4d4f47873e64@fnarfbargle.com>
 <20170616190746.s4ykbmr2tcysimta@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170616190746.s4ykbmr2tcysimta@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids


> I'd like to know your use case, can you describe it in details? I thought only
> raid6check uses this function. If there are other usage cases which depend on
> current behavior, we certaily can't change it.
>
>
It's entirely manual. I have a series of test arrays I use when people 
come to the list with issues and it's not uncommon to get into sysfs to 
manipulate the arrays to either re-create a situation or get the array 
into a state where I can try and figure out what is going on. To be 
honest all the use cases for me are entirely pathological, but it's a 
change to the current behavior that I have used in the past and expect 
to use again in the future.

The issue being rectified is not one I've seen come up frequently (if at 
all) so I thought I'd pipe up and say "I have used this in the past and 
will probably use it again in the future, please don't break it of you 
can avoid it".

I am currently 17,600KM away from my test stuff, so I can't elaborate 
further at the moment.

Regards,
Brad
-- 

Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

