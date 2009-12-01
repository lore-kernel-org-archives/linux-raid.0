From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: md: oops on dropping bitmaps from an array
Date: Tue, 01 Dec 2009 16:08:07 +0000
Message-ID: <4B153F67.5000807@anonymous.org.uk>
References: <200911301500.24223.a.miskiewicz@gmail.com> <20091201121851.45cd4e41@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091201121851.45cd4e41@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/12/2009 01:18, Neil Brown wrote:
> On Mon, 30 Nov 2009 15:00:24 +0100
> Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
[...]
>> [2500705.083965] BUG: unable to handle kernel NULL pointer
>> dereference at
>> (null) [2500705.090142] IP: [<ffffffffa001387a>]
>> bitmap_daemon_work+0x20a/0x500
> 
> That is bad.  I think I can see what is happening.  I suspect that this
> is a fairly hard race to hit - you must been unlucky:-(

I had an oops removing a bitmap a wee while ago, and I mentioned it on 
this list, but I couldn't post a backtrace. I guess I was unlucky too 
but I'm delighted to hear luck's not going to be an issue in the future :-)

Cheers,

John.

