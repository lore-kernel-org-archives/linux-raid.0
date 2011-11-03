From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 00/12] More leak and NULL pointer dereference fixes
Date: Thu, 03 Nov 2011 13:40:36 +0100
Message-ID: <4EB28BC4.2000302@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com> <20111103081251.517d462a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111103081251.517d462a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 11/02/11 22:12, NeilBrown wrote:
>> Jes Sorensen (12):
>> >   mdadm: add missing break for UpdateSubarray
> This was wasn't correct.  The code was actually doing  the right thing.
> But I agree that it looked wrong so I rearranged the code a bit to make it
> (hopefully) less confusing.
> 
> All the rest applied.

Great, thanks for looking through it. This is the one I was mostly
curious about since it wasn't quite clear from the code what the
intentions were.

Cheers,
Jes

