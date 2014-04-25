From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Fri, 25 Apr 2014 08:04:13 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404250802070.19744@uplift.swm.pp.se>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
 <CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com> <20140424215654.0447d300@netstation> <CAK_KU4YUejncX9yQk4HM5HE=1-qPPxOibuRauFheo3jaBc8SaQ@mail.gmail.com> <20140425071340.1ac35ded@netstation>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140425071340.1ac35ded@netstation>
Sender: linux-raid-owner@vger.kernel.org
To: "L.M.J" <linuxmasterjedi@free.fr>
Cc: Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 25 Apr 2014, L.M.J wrote:

> Well, what should I do now ? mkfs everything and restart from scratch ?

Most likely this is your only option. First you overwrote the superblocks 
so the drives came in the wrong order (most likely) and then you ran a 
read/write fsck on it.

The thing to do is to make sure md is read only and use fsck in 
readonly-mode as a diagnostics tool to see if everything is right. If you 
get it wrong and do fsck in read/write mode it's going to change things 
destructively.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
