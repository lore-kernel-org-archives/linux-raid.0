From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: sequential versus random I/O
Date: Wed, 29 Jan 2014 22:58:51 -0200
Message-ID: <CAH3kUhFqWRQMybSfhymd5QTcPhGkDoou8vpmXrgwM+ZnfreWCg@mail.gmail.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
	<CAH3kUhHM-dKXX3z2mo-512=ZL52AM_F547h58nsWRe7LogwbNA@mail.gmail.com>
	<CAH3kUhH1Kq2OO+G2nLCHDoDVsq331pisQSoicmmCvzdC0AS2ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhH1Kq2OO+G2nLCHDoDVsq331pisQSoicmmCvzdC0AS2ow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hummm, another thing.... since you have nfs, you need network...
did you enabled jumbo frames?

http://en.wikipedia.org/wiki/Jumbo_frame
https://wiki.archlinux.org/index.php/Jumbo_Frames

sorry many mails guys, that's the last one =)

2014-01-29 Roberto Spadim <rspadim@gmail.com>:
> check this too:
> http://www.hardwaresecrets.com/article/315
> http://en.wikipedia.org/wiki/Native_Command_Queuing
> http://en.wikipedia.org/wiki/TCQ
>
> http://en.wikipedia.org/wiki/I/O_scheduling
> http://en.wikipedia.org/wiki/Deadline_scheduler
> http://en.wikipedia.org/wiki/CFQ
> http://en.wikipedia.org/wiki/Anticipatory_scheduling
> http://en.wikipedia.org/wiki/Noop_scheduler
>
> http://doc.opensuse.org/products/draft/SLES/SLES-tuning_sd_draft/cha.tuning.io.html
>
> and many others



-- 
Roberto Spadim
