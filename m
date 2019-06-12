From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Wed, 12 Jun 2019 13:38:01 -0300
Message-ID: <845eef8b-d64f-5213-b863-081a72fd5598@canonical.com>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <CAHD1Q_wraiFkLP72pFfGhON+KZe7yo3ktXvsAA40QVcXvzviSA@mail.gmail.com>
 <20190612124834.GA27918@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190612124834.GA27918@kroah.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, sashal@kernel.org, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
List-Id: linux-raid.ids

On 12/06/2019 09:48, Greg KH wrote:
> On Wed, Jun 12, 2019 at 09:40:17AM -0300, Guilherme Piccoli wrote:
>> Hi Greg and Sasha, is there any news about these patches?
> 
> What patches?
> 
>> Just checked the stable branches 5.1.y and 5.0.y, they seem not merged.
> 
> Are they merged in Linus's tree?  What are the git commit ids?
> 

Hi Greg, thanks for your prompt response! The story behind these patches
is a bit confusing; I'll summarize below.

I've submitted 2 patches with fixes to linux-raid in April; if you wanna
take a look, they are:

https://marc.info/?l=linux-raid&m=155839017427565
https://marc.info/?l=linux-raid&m=155839017827569

After some discussion, it was determined a patchset from Ming Lei fixed
the same issues I've reported/fixed, but it was a rework (and depends on
the removal of legacy IO path).
That said, Song Liu submitted both of my fixes as stable-only patches.
I couldn't find a stable archive (and I don't subscribe to that), so I
cannot point links here.

I just resubmitted both patches, this time CCing you and Sasha. Let me
know if there's anything needed - I'd prefer to have them upstream too,
but the discussion with Christoph/Ming/Song reached a consensus that it
wouldn't make sense to add them and soon after add Ming's patchset,
which removes that code.
But backporting Ming's series is not really simple/feasible.

Thanks,


Guilherme


> I have no record of these patches in my queue at the moment, sorry.  If
> these were a backport, please resend them in the proper format.
> 
> thanks,
> 
> greg k-h
> 
