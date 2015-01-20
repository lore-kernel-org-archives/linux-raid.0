From: Phil Turmel <philip@turmel.org>
Subject: Re: kernel refuses devices mdadm -E accepts
Date: Tue, 20 Jan 2015 13:28:23 -0500
Message-ID: <54BE9E47.9030706@turmel.org>
References: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wesley W. Terpstra" <wesley@terpstra.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Wesley,

On 01/19/2015 06:01 PM, Wesley W. Terpstra wrote:

> I was in the middle of a reshape of this 4-disk raid5 when something
> rebooted the computer. The system seems otherwise fine, and I suspect
> someone in the house.
> 
> What is the correct next step? Should I try --run ? I would obviously
> prefer not to lose the data on this array. I expect that the reshape
> was NOT complete, so just recreating the array will probably corrupt
> its contents.
> 
> Kernel version 3.17.8 and mdadm version 3.3.2.

There have been many bug fixes to mdadm since that kernel was retired.
You should temporarily boot a current liveCD (my favorite is
systemrescuecd) and do "mdadm -Afv /dev/mdX /dev/sdX ..."

Show us the output of that if it doesn't work (it should resume your
reshape).

When it is done reshaping/recovering, consider upgrading your kernel.

> Thanks for any help. If I lose this array, I am going to face a lot of grief...

I shouldn't have to say this, but RAID is for availability, not for data
security.  You still need a backup system for any important data.

Phil

