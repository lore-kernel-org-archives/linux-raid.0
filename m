From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Sat, 17 Jun 2017 03:37:56 +0800
Message-ID: <98a7ad64-18f7-3464-8a46-f4f67116c932@fnarfbargle.com>
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



On 17/06/17 03:07, Shaohua Li wrote:
>
> I'd like to know your use case, can you describe it in details? I thought only
> raid6check uses this function. If there are other usage cases which depend on
> current behavior, we certaily can't change it.
>
It occurs to me that my objection is based on a particular workflow and 
there is probably more benefit to the general population to actually 
make the change. I can adapt to whatever changes are made. Sorry for the 
noise.

Regards,
Brad

-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

