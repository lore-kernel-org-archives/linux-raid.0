From: Joe Landman <joe.landman@gmail.com>
Subject: Re: hung grow
Date: Fri, 6 Oct 2017 10:27:28 -0400
Message-ID: <32c5eaa9-c9d2-8fa6-b57b-ab477e5f41fe@gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
 <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk>
 <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
 <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk>
 <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
 <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com>
 <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org>
 <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/06/2017 10:07 AM, Curt wrote:
> On Fri, Oct 6, 2017 at 9:13 AM, Phil Turmel <philip@turmel.org> wrote:

[...]

> Once that is done, I'll run the before mentioned, mdadm assemble force
> revert sda/c/d/g + rescued e and z.  Then start pulling whatever data
> I can off it.

I'd suggest that some data may be more highly valuable than other data 
on there.  So if you can pull that off and stash somewhere, that would 
be recommended before copying everything.  In the past I've made 
tarballs and moved copies around to various locations to preserve 
important data.  Once you have that, do the bigger copy of data.



-- 
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
w: https://scalability.org
g: https://github.com/joelandman

