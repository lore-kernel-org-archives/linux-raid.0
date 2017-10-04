From: Anthony Youngman <anthony@youngman.org.uk>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 20:06:26 +0100
Message-ID: <debafb71-3e26-5b17-3fa1-e8bb38652168@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>, Joe Landman <joe.landman@gmail.com>
Cc: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 19:37, Curt wrote:
> Assuming I can do a dd on one of my failed drives, will I be able to
> recover the data that's on the 4 that were good, before I took bad
> advice?  Also, will I need to dd on the failed drives or can I do 2 of
> the 3?

First, use ddrescue, not dd.

Secondly, you only need one drive to give you "5 out of 7". The most 
recent drive the better!

Cheers,
Wol
